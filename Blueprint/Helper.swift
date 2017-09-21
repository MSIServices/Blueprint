//
//  Helper.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/9/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

struct Helper {
    
    static func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
            
    static func generateRandomBytes() -> [UInt8] {
        
        var bytes = [UInt8]()
        
        for _ in 1...32 {
            bytes.append(UInt8(arc4random_uniform(255)))
        }
        return bytes
    }
    
    static func formatTimeIntervalWithMinutesAndSeconds(currentTime: TimeInterval) -> String {
        
        let dFormat = "%02d"
        let min: Int = Int(currentTime / 60)
        let sec: Int = Int(currentTime.truncatingRemainder(dividingBy: 60.0))
        
        return "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
    }
    
    static func findFirstResponder(inView view: UIView) -> UIView? {
        
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    static func getWiFiAddress() -> String? {
        
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr?.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    //Log all interfaces that start with en
                    if let name = String.init(utf8String: (interface?.ifa_name)!), name.hasPrefix("en") {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        
                        getnameinfo(interface?.ifa_addr, socklen_t(interface!.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        print(String.init(utf8String: hostname))
                    }
                    
                    // Check interface name:
                    if let name = String.init(utf8String: (interface?.ifa_name)!), name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        
                        getnameinfo(interface?.ifa_addr, socklen_t(interface!.ifa_addr.pointee.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        
                        address = String.init(utf8String: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }

}
