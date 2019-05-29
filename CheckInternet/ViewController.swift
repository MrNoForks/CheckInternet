//
//  ViewController.swift
//  CheckInternet
//
//  Created by Boppo Technologies on 29/05/19.
//  Copyright © 2019 Boppo Technologies. All rights reserved.
//

import UIKit
import SystemConfiguration
class ViewController: UIViewController {

//https://github.com/ashleymills/Reachability.swift/blob/feature/ios10/Reachability/Reachability.swift
//https://medium.com/@marcosantadev/network-reachability-with-swift-576ca5070e4b
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2072239737, blue: 0.1368105647, alpha: 1)
        button.setTitle("Tap Me", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        view.addSubview(button)

        
    }
    
    
  @objc  func buttonTapped(sender : UIButton){
        print("I am tapped")
    reachability()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func reachability(){
        //Step1 :- Using a hostname
        let reachability = SCNetworkReachabilityCreateWithName(nil, "localhost")
        
        
        // Or also with localhost
        //let reachability = SCNetworkReachabilityCreateWithName(nil, "localhost")
        
        
        //Step2 :- USing a network address reference
        
        // Initializes the socket IPv4 address struct
        //https://beej.us/guide/bgnet/html/multi/sockaddr_inman.html
        //struct sockaddr_in is for IPv4 struct sockaddr_in6 is for IPv6 and both share struct with sockaddr
        //AF_INET  is an address family that is used to designate the type of addresses that your socket can communicate with (in this case, Internet Protocol v4 addresses).
        //https://stackoverflow.com/questions/1593946/what-is-af-inet-and-why-do-i-need-it
        //https://stackoverflow.com/questions/20217652/af-inet-socket-when-only-ipv6-addresses-are-available-on-system
        //https://linux.die.net/man/7/netdevice
        //        var address = sockaddr_in()
        //        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        //        address.sin_family = sa_family_t(AF_INET)
        //
        //        //Passes the reference of the struct
        //        let ref = withUnsafePointer(to: &address) { (pointer) in
        //
        //            // Converts to a generic socket address
        //            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size, {
        //
        //                // $0 is the pointer to `sockaddr`
        //                return SCNetworkReachabilityCreateWithAddress(nil, $0)
        //            })
        //        }
        
        var address = sockaddr()
        address.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        address.sa_family = sa_family_t(AF_INET)
        
        guard let ref : SCNetworkReachability = withUnsafePointer(to: &address, {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        })else{return }

        
        //Step3 : -
        var flags = SCNetworkReachabilityFlags()
        
        
        //SCNetworkReachabilityGetFlags(<#T##target: SCNetworkReachability##SCNetworkReachability#>, <#T##flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>##UnsafeMutablePointer<SCNetworkReachabilityFlags>#>)
        
        SCNetworkReachabilityGetFlags(ref, &flags)
        
        
        //Then, since flags is a Set, we can check if a flag is available with the method
        
        let isReachable: Bool = flags.contains(.reachable)
        
        let needsConnection = flags.contains(.connectionRequired)
        
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        
        
        //Checking if internet connection is there
       // print(isReachable)
        
        
        
        print(isReachable && (!needsConnection || canConnectWithoutUserInteraction))
        
        //Checking Mobile Connection
        print(flags.contains(.isWWAN))
    }

}

