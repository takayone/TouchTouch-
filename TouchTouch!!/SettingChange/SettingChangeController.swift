//
//  SettingChangeController.swift
//  TouchTouch!!
//
//  Created by takahitoyoneda on 2018/09/05.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase


class SettingChangeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    
    
    @objc func handleTextInputChange(){
        let isFormValid = usernameTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            changeButton.isEnabled = true
            changeButton.backgroundColor = UIColor(red: 17/256, green: 154/256, blue: 237/256, alpha: 1)
        }else{
            changeButton.isEnabled = false
            changeButton.backgroundColor = UIColor(red: 149/256, green: 204/256, blue: 244/256, alpha: 1)
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
    
    
    let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change", for: .normal)
        button.backgroundColor = UIColor(red: 149/256, green: 204/256, blue: 244/256, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleChange(){
        
        guard let username = usernameTextField.text else {return}
            
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
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor(red: 17/256, green: 154/256, blue: 237/256, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBack(){
        let mainViewController = MainViewController()
        present(mainViewController, animated: true, completion: nil)
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
        
    }
    
    fileprivate func setUpInputFields(){
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, changeButton, backButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 60).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
