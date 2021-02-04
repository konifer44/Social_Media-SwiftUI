//
//  LoginViewModel.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import CoreHaptics

class LoginViewModel: ObservableObject{
    @EnvironmentObject var firebase: Firebase
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var registerNewUser = false
    @Published var error = "" {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.error = ""
                }
            }
        }
    }
    @State private var hapticFeedback = UINotificationFeedbackGenerator()
    
    var isPasswordMatch: Bool { password == confirmPassword }
    
    
    func signUp(){
        if isPasswordMatch {
            Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
                if let authResult = authResult {
                    print(authResult.user)
                    self.hapticFeedback.notificationOccurred(.success)
                    self.registerNewUser = false
                }
                
                if let error = error {
                    withAnimation {
                        self.error = error.localizedDescription
                    }
                    self.hapticFeedback.notificationOccurred(.error)
                    print(error.localizedDescription)
                }
            }
        } else {
            withAnimation {
                self.error = "Passwords are different"
            }
            print(error)
            self.hapticFeedback.notificationOccurred(.error)
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password){  [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            if authResult != nil {
                strongSelf.hapticFeedback.notificationOccurred(.success)
            }
            if let error = error {
                print(error.localizedDescription)
                withAnimation {
                    strongSelf.error = error.localizedDescription
                }
                    strongSelf.hapticFeedback.notificationOccurred(.error)
            }
        }
    }
}
