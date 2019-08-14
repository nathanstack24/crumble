//
//  LoginViewController.swift
//  Crumble
//
//  Created by Nathan Stack on 4/26/19.
//  Copyright © 2019 Nathan Stack. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController  {

    var crumbleLogoView : UIImageView!
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    var lineView : UIView!
    let lineViewHeight : CGFloat = 2
    let lineViewYPos : CGFloat = 100
    
    var sliderView: UIView!
    var loginView: LoginView!
    var signupView: SignupView!
    var currentView: UIView!
    var currentUser: User!
    
    let crumbleLogoViewIndent = 70
    let crumbleLogoViewHeight = 25
    let crumbleLogoToButtonOffset = 20
    
    let defaultOffset = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = brownColor
        
        // don't need nav bar for this view
        navigationController?.isNavigationBarHidden = true
        
        // setup orangle horizontal line on login page
        lineView = UIView(frame: CGRect(x: 0, y: lineViewYPos, width: view.frame.width, height: lineViewHeight))
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = orangeColor
        view.addSubview(lineView)
        
        // setup slider view for login / sign up bar
        sliderView = UIView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = grayColor
        view.addSubview(sliderView)
        
        // setup login view
        loginView = LoginView()
        loginView.delegate = self
        currentView = loginView
        view.addSubview(loginView)
        
        // setup sign up view
        signupView = SignupView()
        signupView.isHidden = true // hidden by default
        signupView.delegate = self
        view.addSubview(signupView)
        
        // setup logo image view
        crumbleLogoView = UIImageView()
        crumbleLogoView.translatesAutoresizingMaskIntoConstraints = false
        crumbleLogoView.image = crumbleLogo
        crumbleLogoView.clipsToBounds = true
        crumbleLogoView.contentMode = .scaleAspectFit
        view.addSubview(crumbleLogoView)
        
        // sign in label
        signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.setTitleColor(grayColor, for: .normal)
        signInButton.titleLabel?.font = getDefaultAppFont(ofSize: 16)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        view.addSubview(signInButton)
        
        
        // sign up label
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false // always need for every view
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(grayColor, for: .normal)
        signUpButton.titleLabel?.font = getDefaultAppFont(ofSize: 16)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        setupConstraints()
    }
    
    @objc func signInButtonPressed() {
        if (currentView != loginView) {
            signupView.isHidden = true
            loginView.isHidden = false
            currentView = loginView
        }
        UIView.animate(withDuration: 0.2) {
            self.sliderView.frame = CGRect(x: 0, y: self.sliderView.frame.minY, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
        }
    }
    
    @objc func signUpButtonPressed() {
        if currentView != signupView {
            loginView.isHidden = true
            signupView.isHidden = false
            currentView = signupView
        }
        UIView.animate(withDuration: 0.2) {
            self.sliderView.frame = CGRect(x: self.view.frame.width / 2, y: self.sliderView.frame.minY, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        // Setup constraints for image view
        crumbleLogoView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(crumbleLogoViewIndent)
            make.trailing.equalToSuperview().offset(-crumbleLogoViewIndent)
            make.height.equalTo(crumbleLogoViewHeight)
        }
        
        // Setup constraints for sign in button
        signInButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(view.snp.centerX)
            make.top.equalTo(crumbleLogoView.snp.top).offset(crumbleLogoToButtonOffset)
        }
       
        // Setup constraints for sign up button
        signUpButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalToSuperview()
            make.top.equalTo(crumbleLogoView.snp.top).offset(crumbleLogoToButtonOffset)
        }
        
        // setup constraints for slider bar
        sliderView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.height.equalTo(lineViewHeight).multipliedBy(2)
        }
    
        // setup constraints for horizontal line
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sliderView.snp.bottom)
            make.height.equalTo(1)
        }
    
        // setup login view constraints
        loginView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.top).offset(defaultOffset)
        }
        
        // setup sign up constraints
        signupView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.top).offset(defaultOffset)
        }
    }
    
    
}

extension LoginViewController: LoginViewDelegate {
    func loginAsGuest() {
        let viewController = SearchViewController(addedFilters: [], currentUser: self.currentUser)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func loginWithGoogle() {
        // TODO: determine how to do OAuth with Google
    }
    
    func loginWithFacebook() {
        // TODO: determine how to do OAuth with Facebook
    }
    
    func forgotPassword() {
        // TODO: determine how to deal with forgetting password
    }
    
    func validateData(email: String, password: String) {
        NetworkManager.postEmailAndPassword(email: email, password: password, completion: { (loginDetails) in
            self.currentUser = User(session_token: loginDetails.session_token, session_expiration: loginDetails.session_expiration, update_token: loginDetails.update_token)
            let viewController = SearchViewController(addedFilters: [], currentUser: self.currentUser)
            self.navigationController?.pushViewController(viewController, animated: true)
        }) { (errorMessage) in
            self.createAlert(title: errorMessage, message: "Please enter a valid email and password")
        }
    }
}

extension LoginViewController: SignUpViewDelegate {
    func signUpWithGoogle() {
        // TODO: sign up with Google
    }
    
    func signUpWithFacebook() {
        // TODO: sign up with Facebook
    }
    
    func signUpData(email: String, name: String, password: String) {
        NetworkManager.postNewUser(email: email, name: name, password: password, completion: { (loginDetails) in
            self.currentUser = User(session_token: loginDetails.session_token, session_expiration: loginDetails.session_expiration, update_token: loginDetails.update_token)
            let viewController = SearchViewController(addedFilters: [], currentUser: self.currentUser)
            self.navigationController?.pushViewController(viewController, animated: true)
        }) { (errorMessage) in
            self.createAlert(title: errorMessage, message: "Please enter a valid email, name, and password")
            self.sliderView.frame = CGRect(x: self.view.frame.width / 2, y: self.sliderView.frame.minY, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
            
        }
    }
}
