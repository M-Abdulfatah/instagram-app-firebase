//
//  ViewController.swift
//  Instgram
//
//  Created by Mahmoud Mohammed on 9/9/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftyJSON


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var facebookUser = FacebookUserModel()
    
    
    var fileName = String()
    let plusPhotoBtton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoBtton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoBtton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoBtton.layer.cornerRadius = plusPhotoBtton.layer.frame.width/2
        plusPhotoBtton.layer.masksToBounds = true
        plusPhotoBtton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        plusPhotoBtton.layer.borderWidth = 3
        let fileurl = info["UIImagePickerControllerImageURL"] as! URL
        fileName = fileurl.description
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17,green: 154,blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignUp() {
        var profileImageUrl = ""
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
            
            if let err = error {
                print("faild to create user:",err.localizedDescription )
                return
            }
            
            print("Created user successfully:", (userData?.user.uid)!)
            
            guard let image = self.plusPhotoBtton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metaData, err) in
                if let err = err {
                    print("Failed to upload profile Image: ", err.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    guard let downloadurl = url else { return }
                     profileImageUrl = downloadurl.absoluteString
                    print("downloadURL", downloadurl)
                    print("DownloadAbsolute", downloadurl.absoluteString)
                    
                    print("Successfully uploaded profile Image: ", profileImageUrl)
                    
                    guard let uid = userData?.user.uid else { return }
                    
                    let usernameValues = ["username":username, "profileImageUrl": profileImageUrl]
                    let values = [uid: usernameValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Faild to save user info to db:",err)
                            return
                        }
                        print("Succefully saved user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                })
                
               
            })
            
        }
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedtitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        attributedtitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedtitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleAlredyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlredyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(plusPhotoBtton)
        plusPhotoBtton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        setupFBLoginBtn()
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: plusPhotoBtton.bottomAnchor, constant: 20),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                     stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                                     stackView.heightAnchor.constraint(equalToConstant: 200)])
        
        
        stackView.anchor(top: plusPhotoBtton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
}

// This is where I handle Login with Facebook
extension SignUpController: LoginButtonDelegate {
    
    func setupFBLoginBtn() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email])
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.anchor(top: signUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
        
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        fetchFBUserData() 
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged Out")
    }
    
    
    
    func fetchFBUserData() {
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                self.facebookUser = response.facebookUserData
                print("This is the user Email:",self.facebookUser.email)
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
}

















