//
//  LoginController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/07/03.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController{
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "touchButton"))
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(red: 0/255, green: 120/255, blue: 175/255, alpha: 1)
        return view
    }()
    
//    let logContainerView: UIView = {
//        let view = UIView()
//        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
//
//        view.addSubview(logoImageView)
//        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
//        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        logoImageView.contentMode = .scaleAspectFill
//        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
//        return view
//    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        //        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let err = err{
                print("failed to login", err)
            }
            
//            guard let mainViewController = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else{return}
//            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
        
    }
    
    
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(logContainerView)
//        logContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

        view.addSubview(logoContainerView)
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        logoContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        logoContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        logoContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        dontHaveAccountButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dontHaveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dontHaveAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
//
        setupInputField()
    }
    
    fileprivate func setupInputField(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 50).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
//        stackView.anchor(top: logContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
