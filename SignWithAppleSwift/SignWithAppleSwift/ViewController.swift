//
//  ViewController.swift
//  SignWithAppleSwift
//
//  Created by Daniel Ayala Jabon on 03/10/2019.
//  Copyright © 2019 imediayala. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button  = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleIDButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        
    }
    
    //MARK: Response to user Authorization
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        switch authorization.credential {
        // Create an account in your system.
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            _ = appleIDCredential.user
            _ = appleIDCredential.email
            appleIDStateChanged(userIdentifier: appleIDCredential.user)
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            appleIDStateChanged(userIdentifier: passwordCredential.user)
        default: break
        }
    }
    
    //MARK: Existing Accounts
    fileprivate func performExistingAccountSetupFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //MARK: Open Login Dialog
    @objc func appleIDButtonTapped(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    //MARK: Handling Changes in Apple ID State
    fileprivate func appleIDStateChanged(userIdentifier: String){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            switch credentialState {
            // The Apple ID credential is valid. Show Home UI Here
            case .authorized: break
            // The Apple ID credential is revoked. Show SignIn UI Here.
            case .revoked: break
            // No credential was found. Show SignIn UI Here.
            case .notFound: break
            default: break
            }
        }
    }
    
}

//MARK: ASAuthorizationControllerDelegate
extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}
