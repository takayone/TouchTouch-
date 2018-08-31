//
//  SignUpController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/07/03.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 17/256, green: 154/256, blue: 237/256, alpha: 1)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/256, green: 204/256, blue: 244/256, alpha: 1)
        }
        
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
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
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/256, green: 204/256, blue: 244/256, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let errorScreenLabel: UILabel = {
        let label = UILabel()
        label.text = "Error. Please put valid e-mail and password should be over 6 characters."
        label.textColor = UIColor.red
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 3
        return label
    }()
    
    @objc func handleSignUp(){
        
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            
            if let err = error {
                print("failed to creat user", err)
                self.errorScreenLabel.isHidden = false
                return
            }
            
            
            guard let image = self.plusPhotoButton.imageView?.image else{return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else{return}
            guard let uid = Auth.auth().currentUser?.uid else{return}
            let storageRef = Storage.storage().reference()
            let storageRefChild = storageRef.child("user_profile\(uid).jpg")
            storageRefChild.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("unable to upload image into storage due to: \(err)")
                    return
                }
                
                storageRefChild.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("unable to retrieve URL due to error:\(err.localizedDescription)")
                        return
                    }
                    let profileImageUrl = url?.absoluteString
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err{
                            print("failed to save user info:", err)
                        }
                        
                        print("successfully saved user info into db")
   
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                })
            })
        }
    }
    
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor(red: 17/256, green: 154/256, blue: 237/256, alpha: 1)
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccountButton(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        
        setUpPlusandAccountButton()

        setUpInputFields()
    }
    
    fileprivate func setUpPlusandAccountButton(){
        plusPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusPhotoButton)
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        alreadyHaveAccountButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        alreadyHaveAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setUpInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
   
        stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 60).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        errorScreenLabel.isHidden = true
        view.addSubview(errorScreenLabel)
        errorScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        errorScreenLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        errorScreenLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        errorScreenLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        errorScreenLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
