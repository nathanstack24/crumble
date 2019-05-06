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
    var currentUser: User!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.contentMode = .scaleAspectFill
        backgroundColor = UIColor(displayP3Red: 0.29803922, green: 0.19607843, blue: 0.14509804, alpha: 1)
        grayColor = UIColor(displayP3Red: 0.96862745, green: 0.9254902, blue: 0.79215686, alpha: 1)
        orangeColor = UIColor(displayP3Red: 0.83529412, green: 0.52156863, blue: 0.24313725, alpha: 1)
        view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.barStyle = .blackOpaque
        
        
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
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        view.addSubview(signInButton)
        
        
        // sign up label
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false // always need for every view
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(grayColor, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
            crumbleLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            crumbleLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            crumbleLogoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -70),
            ])
        // Setup constraints for sign in button
        NSLayoutConstraint.activate([
            signInButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90)
             ])
        // Setup constraints for sign up button
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90)
            ])
        // setup constraints for slider bar
        NSLayoutConstraint.activate([
            sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sliderView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            sliderView.heightAnchor.constraint(equalToConstant: 2),
            sliderView.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor)
            ])
    
        // setup constraints for horizontal line
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: sliderView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
            ])
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
            signupView.topAnchor.constraint(equalTo: lineView.topAnchor, constant: 10),
            signupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension LoginViewController: LoginViewDelegate {
    func validateData(email: String, password: String) {
        NetworkManager.postEmailAndPassword(email: email, password: password, completion: { (loginDetails) in
            print(loginDetails)
        }) { (errorMessage) in
            self.createAlert(title: errorMessage, message: "Please enter a valid email and password")
        }
    }
}

extension LoginViewController: SignUpViewDelegate {
    func signUpData(email: String, name: String, password: String) {
        NetworkManager.postNewUser(email: email, name: name, password: password, completion: { (loginDetails) in
            let viewController = SearchViewController(addedFilters: [])
            self.navigationController?.pushViewController(viewController, animated: true)
        }) { (errorMessage) in
            self.createAlert(title: errorMessage, message: "Please enter a valid email, name, and password")
            self.sliderView.frame = CGRect(x: self.view.frame.width / 2, y: self.sliderView.frame.minY, width: self.sliderView.frame.width, height: self.sliderView.frame.height)
            
        }
    }
}

extension LoginViewController: LoginAsGuestDelegate {
    func loginAsGuest() {
        let viewController = SearchViewController(addedFilters: [])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
