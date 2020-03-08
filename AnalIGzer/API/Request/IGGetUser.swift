//
//  IGGetUser.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 27/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import CoreData

protocol IGGetUserDelegate {
    func getUser(withSuccess success: IGUserModel)
    func getUser(withPrimal primalData: IGPrimalModel)
    func getUser(withError error: String)
}

class IGGetUser {
    
    var delegate: IGGetUserDelegate?
    
    func getPrimalData(userID: String) {
        
        let path = "https://www.instagram.com/graphql/query/?query_hash=7c16654f22c819fb63d1183034a5162f&variables=%7B%22user_id%22%3A%22\(userID)%22%2C%22include_chaining%22%3Atrue%2C%22include_reel%22%3Atrue%2C%22include_suggested_users%22%3Atrue%2C%22include_logged_out_extras%22%3Afalse%2C%22include_highlight_reels%22%3Afalse%7D"
        
        guard let url = URL(string: path) else {
            return
        }
        var uri = URLRequest(url: url)
        
        uri.addValue(IGSavedData.cookies, forHTTPHeaderField: "cookie")
        
        let task = URLSession.shared.dataTask(with: uri) { (data, urlResponse, error) in
            
            guard let response = data else { return }
            guard error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(IGPrimalModel.self, from: response)
                
                DispatchQueue.main.async {
                    self.delegate?.getUser(withPrimal: user)
                }
                
            } catch let err {
                
                DispatchQueue.main.async {
                    self.delegate?.getUser(withError: err.localizedDescription)
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func getUser(user: String) {
        
        let path = "https://www.instagram.com/\(user)/?__a=1"
     
        print(path)
        guard let url = URL(string: path) else {
            return
        }
        var uri = URLRequest(url: url)
        uri.addValue(IGSavedData.cookies, forHTTPHeaderField: "cookie")
        
        let task = URLSession.shared.dataTask(with: uri) { (data, urlResponse, error) in
            
            guard let response = data else { return }
            guard error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(IGUserModel.self, from: response)
                
                DispatchQueue.main.async {
                    self.delegate?.getUser(withSuccess: user)
                }
                
            } catch let err {
                
                DispatchQueue.main.async {
                    self.delegate?.getUser(withError: err.localizedDescription)
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func saveOwner(_ user: IGUserModel) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Owner", in: managedContext) else { return }
        let owner = NSManagedObject(entity: entity, insertInto: managedContext)
        
        owner.setValue(user.graphql?.user?.id, forKey: "id")
        owner.setValue(user.graphql?.user?.id, forKey: "biography")
        owner.setValue(user.graphql?.user?.id, forKey: "full_name")
        owner.setValue(user.graphql?.user?.id, forKey: "profile_pic_url")
        owner.setValue(user.graphql?.user?.id, forKey: "username")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}
