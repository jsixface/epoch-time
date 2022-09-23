//
//  MainViewController.swift
//  Ambar
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Anagh Sharma. All rights reserved.
//

import AppKit

class MainViewController: NSViewController {
    override func viewDidAppear()
    {
        super.viewDidAppear()

        // You can use a notification and observe it in a view model where you want to fetch the data for your SwiftUI view every time the popover appears.
        NotificationCenter.default.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
}


class ClipboardModel: ObservableObject {
    @Published var timestamp = ""
    
    private let localFormat = DateFormatter()
    private let gmtFormat = DateFormatter()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ViewDidAppear"), object: nil)
        
        localFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        localFormat.timeZone = TimeZone.current
        gmtFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        gmtFormat.timeZone = TimeZone.init(secondsFromGMT: 0)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        let clipValue = NSPasteboard.general.pasteboardItems?.first?.string(forType: NSPasteboard.PasteboardType.string)
        if let clipValue {
            
            let value = clipValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if let number = UInt64(value) {
                
                var stamp: Double
                if number <= UInt32.max {
                    stamp =  Double(number)
                } else {
                    stamp =    Double(number)/1000
                }
                let date = Date(timeIntervalSince1970: stamp)
                self.timestamp = """
                Local:
                \(localFormat.string(from: date))
                
                UTC:
                \(gmtFormat.string(from: date))
                """
                
            } else {
                self.timestamp = "Copied text is not a valid timestamp"
            }
            
        }
    }
}
