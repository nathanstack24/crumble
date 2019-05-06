//
//  LoginViewController.swift
//  Crumble
//
//  Created by Nathan Stack on 4/26/19.
//  Copyright © 2019 Beth Mieczkowski. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController  {

    var crumbleLogoView : UIImageView!
    var crumbleLogo: UIImage!
    var distFromTop: Int!
    var backgroundColor: UIColor!
    var grayColor: UIColor!
    var orangeColor: UIColor!
    var signInButton: UIButton!
    var signUpButton: UIButton!
    var horizontalLine: CGRect!
    var lineView : UIView!
    
    var sliderView: UIView!
    var loginView: LoginView!
    var signupView: SignupView!
    var currentView: UIView!
    var currentUser: User! = User(session_token: "abc", session_expiration: "abc", update_token: "abc")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.contentMode = .scaleAspectFill
        backgroundColor = UIColor(red: 76/255, green: 50/255, blue: 37/255, alpha: 1)
        grayColor = UIColor(red: 247/255, green: 236/255, blue: 202/255, alpha: 1)
        orangeColor = UIColor(red: 254/255, green: 164/255, blue: 49/255, alpha: 1)
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.barStyle = .blackOpaque
        
/*        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = UIColor(white: 0.95, alpha:1)
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)*/
        
        // setup horizontal line on login page
        horizontalLine = CGRect(x: 0, y: 100, width: view.frame.width, height: 5)
        lineView = UIView(frame: horizontalLine)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = orangeColor
        view.addSubview(lineView)
        
        // setup slider view for login / sign up bar
        sliderView = UIView()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = grayColor
        view.addSubview(sliderView)
        
        // setup login view
        loginView = LoginView(brownColor: backgroundColor, grayColor: grayColor, orangeColor: orangeColor)
        loginView.delegate = self
        loginView.guestDelegate = self
        currentView = loginView
        view.addSubview(loginView)
        loginSetupConstraints()
        
        // setup sign up view
        signupView = SignupView(brownColor: backgroundColor, grayColor: grayColor, orangeColor: orangeColor)
        signupView.isHidden = true
        signupView.delegate = self
        signupView.guestDelegate = self
        view.addSubview(signupView)
        signUpSetupConstraints()
        
        
        // setup logo image view
        crumbleLogoView = UIImageView() // creates a new UIImageView instance
        crumbleLogoView.translatesAutoresizingMaskIntoConstraints = false
        crumbleLogoView.image = UIImage(named: "loginLogo")
        crumbleLogoView.clipsToBounds = true // image clipped to bounds of the receiver
        crumbleLogoView.contentMode = .scaleAspectFit
        view.addSubview(crumbleLogoView)
        
        // sign in label
        signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false // always need for every view
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.setTitleColor(grayColor, for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        view.addSubview(signInButton)
        
        
        // sign up label
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false // always need for every view
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(grayColor, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
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
        if (currentView != signupView) {
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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupConstraints() {
        // Setup constraints for image view
        NSLayoutConstraint.activate([
            crumbleLogoView.heightAnchor.constraint(equalToConstant: 165),
            crumbleLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            crumbleLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            crumbleLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 25),
            ])
        // Setup constraints for sign in button
        NSLayoutConstraint.activate([
            signInButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInButton.topAnchor.constraint(equalTo: crumbleLogoView.bottomAnchor,constant: 20),
            //signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90)
             ])
        // Setup constraints for sign up button
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpButton.topAnchor.constraint(equalTo: crumbleLogoView.bottomAnchor,constant: 20),
            //signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90)
            ])
        // setup constraints for slider bar
        NSLayoutConstraint.activate([
            sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sliderView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            sliderView.heightAnchor.constraint(equalToConstant: 2),
            sliderView.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 5)
            ])
    
        // setup constraints for horizontal line
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: sliderView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
//            ])
    }
    
    func loginSetupConstraints () {
        // setup login constraints
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 10),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func signUpSetupConstraints () {
        // setup sign up constraints
        NSLayoutConstraint.activate([
            signupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signupView.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 20),
            signupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    
}

extension LoginViewController: LoginViewDelegate {
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

extension LoginViewController: LoginAsGuestDelegate {
    func loginAsGuest() {
        let viewController = SearchViewController(addedFilters: [], currentUser: self.currentUser)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
