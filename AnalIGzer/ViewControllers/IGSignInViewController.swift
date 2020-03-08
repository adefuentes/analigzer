//
//  ViewController.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 17/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import SwiftInstagram
import Pastel

class IGSignInViewController: UIViewController {

    var accessButton: UIButton!
    var userTextField: UITextField!
    var passTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionDissmisKeyboard(_:)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        accessButton.addTarget(self, action: #selector(actionOpenLogin(_:)), for: .touchUpInside)
    }

    @objc func actionOpenLogin(_ sender: UIButton) {
        
        let accessPlatform = IGAccessPlatform()
        accessPlatform.delegate = self
        accessPlatform.access(user: userTextField.text ?? "", pass: passTextField.text ?? "")
        
    }
    
    @objc func actionDissmisKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension IGSignInViewController: IGAccessPlatformDelegate {
    
    func access(withResult: IGAccessModel) {
        
        let viewController = IGMainViewController()
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        
    }
    
    func access(withError: String) {
        let alert = UIAlertController(title: "Oh oh!", message: withError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension IGSignInViewController {
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        let iconApp = UIImageView(image: UIImage(named: "logo-instagram")?.withRenderingMode(.alwaysTemplate))
        let pastelView = PastelView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        let analyticLabel = UILabel()
        
        analyticLabel.textColor = .white
        analyticLabel.text = "AnalIGzer"
        analyticLabel.font = UIFont(name: "Billabong", size: 80)
        analyticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        accessButton = {
           
            let button = UIButton()
            button.backgroundColor = kPALETTE_COLORS[1]
            button.layer.cornerRadius = 5
            button.setTitle("Accede con Instagram", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            
            return button
            
        }()
        
        userTextField = {
           
            let textField = UITextField()
            
            textField.backgroundColor = UIColor(white: 0.97, alpha: 1)
            textField.placeholder = "Usuario"
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.borderWidth = 0.5
            
            return textField
            
        }()
        
        passTextField = {
            
            let textField = UITextField()
            
            textField.backgroundColor = UIColor(white: 0.97, alpha: 1)
            textField.placeholder = "Contraseña"
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 0.5
            textField.isSecureTextEntry = true
            
            return textField
            
        }()
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        accessButton.translatesAutoresizingMaskIntoConstraints = false
        
        iconApp.contentMode = .scaleAspectFit
        iconApp.tintColor = .white
        iconApp.translatesAutoresizingMaskIntoConstraints = false
        
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        pastelView.animationDuration = 3.0
        
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.addSubview(pastelView)
        view.addSubview(iconApp)
        view.addSubview(analyticLabel)
        view.addSubview(userTextField)
        view.addSubview(passTextField)
        view.addSubview(accessButton)
        
        view.addConstraintsWithFormat(visualFormat: "V:|-80-[v0]-(-20)-[v1(60)]", views: analyticLabel, iconApp)
        view.addConstraintsWithFormat(visualFormat: "V:|-[v0]-48-[v1(50)]-16-[v2(50)]-24-[v3(60)]", views: pastelView, userTextField, passTextField, accessButton)
        view.addConstraintsWithFormat(visualFormat: "H:[v0(300)]", views: userTextField)
        view.addConstraintsWithFormat(visualFormat: "H:[v0(300)]", views: passTextField)
        view.addConstraintsWithFormat(visualFormat: "H:[v0(300)]", views: accessButton)
        view.centerHorizontalWithConstraints(iconApp)
        view.centerHorizontalWithConstraints(analyticLabel)
        view.centerHorizontalWithConstraints(userTextField)
        view.centerHorizontalWithConstraints(passTextField)
        view.centerHorizontalWithConstraints(accessButton)
        
    }
    
}
