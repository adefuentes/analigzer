//
//  IGAcessPlatform.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 25/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import CoreData


protocol IGAccessPlatformDelegate {
    func access(withError: String)
    func access(withResult: IGAccessModel)
}

class IGAccessPlatform {
    
    public var delegate: IGAccessPlatformDelegate?
    func access(user: String, pass: String) {
        
        let path = "https://www.instagram.com/accounts/login/ajax/"
        let query = "username=\(user)&password=\(pass)&queryParams=%7B%22source%22%3A%22auth_switcher%22%7D"
        
        guard let url = URL(string: path) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = query.data(using: .utf8)
        
        print(IGSavedData.cookies)
        
        request.addValue("csrftoken=HJY6n41CFiT3Lk8zH9VFvgCDXABNGQcz;", forHTTPHeaderField: "cookie")
        request.addValue("HJY6n41CFiT3Lk8zH9VFvgCDXABNGQcz", forHTTPHeaderField: "x-csrftoken")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if error != nil { return }
            
            do {
                let access = try JSONDecoder().decode(IGAccessModel.self, from: data)
                if access.authenticated ?? false {
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        return
                    }
                    
                    let setCookieString: String = httpResponse.allHeaderFields["Set-Cookie"] as? String ?? ""
                    let setCookieArr: [String.SubSequence] = setCookieString.split(separator: ";")
                    
                    var session: String = ""
                    
                    for cookie in setCookieArr {
                        if cookie.contains("sessionid") {
                            session = String(cookie.split(separator: " ")[1])
                        }
                    }
                    
                    IGSavedData.cookies = session
                    
                    if access.user ?? false {
                        
                        IGSavedData.userID = access.userId ?? ""
                        
                        DispatchQueue.main.async {
                            self.delegate?.access(withResult: access)
                        }
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.delegate?.access(withError: error.localizedDescription)
                }
            }
            
            //print((response as! HTTPURLResponse).allHeaderFields["Set-Cookie"])
        }.resume()
        
    }
    
}
