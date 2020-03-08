//
//  IGGetPublicIP.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 20/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

open class IGPublicIP {
    
    private func getDataFromUrl(urL: URL, completion: @escaping ((_ data: Data?) -> Void)) {
        
        URLSession.shared.dataTask(with: urL) { (data, response, error) in
            completion(data)
        }.resume()
        
    }
    
    private var previousIP: String!
    
    private var timer: Timer!
    
    
    init(){
        previousIP = nil
        timer = nil
    }
    
    
    func getCurrentIP(completion:@escaping ((_ ip : String?) -> Void)){
        
        if let checkedUrl = URL(string: "https://api.ipify.org?format=json") {
            getDataFromUrl(urL: checkedUrl, completion: { (data) -> Void in
                
                do {
                    let parsedObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    if let jsonIP = parsedObject as? [String: String] {
                        
                        DispatchQueue.main.async {
                            
                            completion(jsonIP["ip"])
                            
                        }
                    }
                } catch let error {
                    print(error)
                }
                
                
            })
        }
        
    }
    
    func checkForCurrentIP(completion:@escaping ((_ ip : String?) -> Void), interval: TimeInterval){
        
        if self.timer != nil { self.stopChecking() }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _  in
            self.getCurrentIP(completion: { (ip) -> Void in
                
                if (self.previousIP != nil){
                    
                    if self.previousIP != ip {
                        
                        self.previousIP = ip
                        completion(ip)
                        
                    }
                    
                } else {
                    self.previousIP = ip
                    completion(ip)
                }
                
                
            })
        })
        // Execute timer immediately (don't wait for first interval)
        self.timer.fire()
        
    }
    
    
    func stopChecking(){
        
        self.timer.invalidate()
        self.timer = nil
        
    }
}
