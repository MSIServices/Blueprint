//
//  ReachabilityManager.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 9/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()!
    
    var isNetworkAvailable: Bool {
        return reachability.connection == .wifi
    }
    
    var isCellularAvailable: Bool {
        return reachability.connection == .cellular
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .none:
            debugPrint("Network NOT available.")
        case .wifi:
            debugPrint("WiFi is available!")
            
            if Helper.fetchSSIDInfo() == "msi_emp" {
                print("Sync with Server...")
            }
        case .cellular:
            debugPrint("Cellular is available!")
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring() {
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }

}
