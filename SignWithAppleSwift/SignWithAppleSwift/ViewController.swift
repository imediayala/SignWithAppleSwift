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
        case let credential as ASAuthorizationAppleIDCredential:
            if let email = credential.email {
                signWithEmail(email: email)
            }
        case let credential as ASPasswordCredential:
            let user = credential.user
            signWithUserId(userID: user)
        default: break
        }
    }
    
    fileprivate func signWithEmail(email: String){
        
    }
    
    fileprivate func signWithUserId(userID: String){
        
    }
    
//    fileprivate func addObserverForAppeIDChangeNotification(){
//        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateChanged), name: NSNotification.Name.ASAuthorizationAppleIDProviderCredentialRevoked, object: nil)
//    }
    
    //MARK: Existing Accounts
    fileprivate func performExistingAccountSetupFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //MARK: Open the Dialog
    @objc func appleIDButtonTapped(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    //MARK: Handling Changes in Apple ID State
    @objc func appleIDStateChanged(){
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: "") { (credentialState, error) in
            switch(credentialState){
            case .authorized: break
            case .revoked: break
            case .notFound: break
            default: break
            }
        }
    }
    
    
    
}

extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return UIWindow()
    }
    
    
}
