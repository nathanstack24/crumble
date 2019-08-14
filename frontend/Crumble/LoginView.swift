//
//  LoginView.swift
//  Crumble
//
//  Created by Nathan Stack on 5/5/19.
//  Copyright © 2019 Nathan Stack. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginViewDelegate: class  {
    func validateData(email: String, password: String)
    func loginAsGuest()
    func loginWithGoogle()
    func loginWithFacebook()
    func forgotPassword()
}

class LoginView: UIView {

    var emailTextField : UITextField!
    var emailLabel : UILabel!
    var emailLineView: UIView!
    
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var passwordLineView: UIView!
    
    var forgotPasswordButton: UIButton!
    var loginButton: UIButton!
    var loginWithFacebookButton: UIButton!
    var facebookLogoView: UIImageView!
    var loginWithGoogleButton: UIButton!
    var googleLogoView: UIImageView!
    var loginAsGuestButton: UIButton!
    weak var delegate: LoginViewDelegate?
    
    let buffer: CGFloat = 50
    let distFromTop: CGFloat = 15
    let buttonHeight: CGFloat = 50
    let lineViewHeight: CGFloat = 2
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = brownColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // label for email
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.font = getDefaultAppFont(ofSize: 16)
        emailLabel.textColor = orangeColor
        self.addSubview(emailLabel)
        
        // email text field
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = brownColor
        emailTextField.borderStyle = .none
        emailTextField.clipsToBounds = true
        emailTextField.textColor = grayColor
        self.addSubview(emailTextField)
        
        // email line
        emailLineView = UIView()
        emailLineView.translatesAutoresizingMaskIntoConstraints = false
        emailLineView.backgroundColor = orangeColor
        self.addSubview(emailLineView)
        
        // label for password
        passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.font = getDefaultAppFont(ofSize: 16)
        passwordLabel.textColor = orangeColor
        self.addSubview(passwordLabel)
        
        // password text field
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.backgroundColor = brownColor
        passwordTextField.borderStyle = .none
        passwordTextField.clipsToBounds = true
        passwordTextField.textColor = grayColor
        passwordTextField.isSecureTextEntry = true
        self.addSubview(passwordTextField)
        
        // password line
        passwordLineView = UIView()
        passwordLineView.translatesAutoresizingMaskIntoConstraints = false
        passwordLineView.backgroundColor = orangeColor
        self.addSubview(passwordLineView)
        
        // forgot password button
        forgotPasswordButton = UIButton()
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setAttributedTitle(NSAttributedString(string: "Forgot Password?", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : grayColor]), for: .normal)
        forgotPasswordButton.titleLabel?.font = getDefaultAppFont(ofSize: 16)
        forgotPasswordButton.setTitleColor(grayColor, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        self.addSubview(forgotPasswordButton)
        
        // login button
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = grayColor
        loginButton.setTitleColor(brownColor, for: .normal)
        loginButton.titleLabel?.font = getDefaultAppFont(ofSize: 18)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        loginButton.layer.cornerRadius = 8
        self.addSubview(loginButton)
        
        // login with Facebook button
        loginWithFacebookButton = UIButton()
        loginWithFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        loginWithFacebookButton.setTitle("Login with Facebook", for: .normal)
        loginWithFacebookButton.setTitleColor(brownColor, for: .normal)
        loginWithFacebookButton.backgroundColor = grayColor
        loginWithFacebookButton.titleLabel?.font = getDefaultAppFont(ofSize: 18)
        loginWithFacebookButton.layer.cornerRadius = 8
        loginWithFacebookButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        loginWithFacebookButton.isHidden = true
        self.addSubview(loginWithFacebookButton)
        
        // facebook logo
        facebookLogoView = UIImageView()
        facebookLogoView.translatesAutoresizingMaskIntoConstraints = false
        facebookLogoView.image = UIImage(named: "facebookLogo")
        facebookLogoView.clipsToBounds = true
        facebookLogoView.layer.cornerRadius = 5
        facebookLogoView.contentMode = .scaleAspectFit
        facebookLogoView.isHidden = true
        self.addSubview(facebookLogoView)
        
        // login with Google button
        loginWithGoogleButton = UIButton()
        loginWithGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        loginWithGoogleButton.setTitle("Login with Google", for: .normal)
        loginWithGoogleButton.setTitleColor(brownColor, for: .normal)
        loginWithGoogleButton.backgroundColor = grayColor
        loginWithGoogleButton.titleLabel?.font = getDefaultAppFont(ofSize: 18)
        loginWithGoogleButton.layer.cornerRadius = 8
        loginWithGoogleButton.addTarget(self, action: #selector(googleLoginButtonPressed), for: .touchUpInside)
        loginWithGoogleButton.isHidden = true
        self.addSubview(loginWithGoogleButton)
        
        // google logo
        googleLogoView = UIImageView()
        googleLogoView.translatesAutoresizingMaskIntoConstraints = false
        googleLogoView.image = googleLogo
        googleLogoView.clipsToBounds = true // image clipped to bounds of the receiver
        googleLogoView.layer.cornerRadius = 17.5
        googleLogoView.contentMode = .scaleAspectFit
        googleLogoView.isHidden = true
        self.addSubview(googleLogoView)
        
        // login as guest
        loginAsGuestButton = UIButton()
        loginAsGuestButton.translatesAutoresizingMaskIntoConstraints = false
        loginAsGuestButton.setAttributedTitle(NSAttributedString(string: "Login as Guest", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : grayColor]), for: .normal)
        loginAsGuestButton.titleLabel?.font = getDefaultAppFont(ofSize: 16)
        loginAsGuestButton.setTitleColor(grayColor, for: .normal)
        loginAsGuestButton.addTarget(self, action: #selector(loginAsGuestButtonPressed), for: .touchUpInside)
        self.addSubview(loginAsGuestButton)
    
        setupConstraints()
    }
    
    @objc func loginButtonPressed () {
        if let email = emailTextField.text, let password = passwordTextField.text {
            delegate?.validateData(email: email, password: password)
        }
        else {
        }
    }
    
    @objc func forgotPasswordButtonPressed () {
        delegate?.forgotPassword()
    }
    
    @objc func facebookLoginButtonPressed () {
        delegate?.loginWithFacebook()
    }
    
    @objc func googleLoginButtonPressed () {
        delegate?.loginWithGoogle()
    }
    
    @objc func loginAsGuestButtonPressed () {
        delegate?.loginAsGuest()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        // constraints for email label
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            emailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.distFromTop)
            ])
        // constraints for email text field
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (-self.buffer)),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5)
            ])
        // constraints for email line
        NSLayoutConstraint.activate([
            emailLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            emailLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (-self.buffer)),
            emailLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            emailLineView.heightAnchor.constraint(equalToConstant: lineViewHeight)
            ])
        // constraints for password label
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            passwordLabel.topAnchor.constraint(equalTo: emailLineView.bottomAnchor, constant: 20)
            ])
        // constraints for password text field
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (-self.buffer)),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5)
            ])
        // constraints for password line
        NSLayoutConstraint.activate([
            passwordLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.buffer),
            passwordLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (-self.buffer)),
            passwordLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            passwordLineView.heightAnchor.constraint(equalToConstant: 2)
            ])
        // forgot password button
        NSLayoutConstraint.activate([
            forgotPasswordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordLineView.bottomAnchor, constant: 15)
            ])
        // login button
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buffer),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -buffer),
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 15),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        // facebook login button
        NSLayoutConstraint.activate([
            loginWithFacebookButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buffer),
            loginWithFacebookButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -buffer),
            loginWithFacebookButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            loginWithFacebookButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        // facebook label button
        NSLayoutConstraint.activate([
            facebookLogoView.trailingAnchor.constraint(equalTo: loginWithFacebookButton.trailingAnchor, constant: -15
            ),
            facebookLogoView.widthAnchor.constraint(equalToConstant: 30),
            facebookLogoView.heightAnchor.constraint(equalToConstant: 30),
            facebookLogoView.centerYAnchor.constraint(equalTo: loginWithFacebookButton.centerYAnchor)
            ])
        // google login button
        NSLayoutConstraint.activate([
            loginWithGoogleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: buffer),
            loginWithGoogleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -buffer),
            loginWithGoogleButton.topAnchor.constraint(equalTo: loginWithFacebookButton.bottomAnchor, constant: 20),
            loginWithGoogleButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        // google label button
        NSLayoutConstraint.activate([
            googleLogoView.trailingAnchor.constraint(equalTo: loginWithGoogleButton.trailingAnchor, constant: -15),
            googleLogoView.widthAnchor.constraint(equalToConstant: 30),
            googleLogoView.heightAnchor.constraint(equalToConstant: 30),
            googleLogoView.centerYAnchor.constraint(equalTo: loginWithGoogleButton.centerYAnchor)
            ])
        // login as guest button
        NSLayoutConstraint.activate([
            loginAsGuestButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginAsGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            ])
    }
}
