//
//  InterfaceController.swift
//  WeatherMateWatch Extension
//
//  Created by Samrat on 11/5/16.
//  Copyright © 2016 SMRT. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {

    /// The session variable that will be used to communicate with the watch
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Initialize the session
        session = WCSession.defaultSession()
        
        // Important to check that the session is supported
        if WCSession.isSupported() && session!.reachable {
            
            session!.sendMessage(["getUpdate": ""], replyHandler: { (response) -> Void in
                let arr = response[Constants.WatchKeys.KEY_CITIES] as! Array<Dictionary<String,AnyObject>>
                // Now start updating the conrollers
                let controllers = Array(count: arr.count, repeatedValue: "City")
                WKInterfaceController.reloadRootControllersWithNames(controllers, contexts: arr)
                }, errorHandler: { (error) -> Void in
            })
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
    
}
