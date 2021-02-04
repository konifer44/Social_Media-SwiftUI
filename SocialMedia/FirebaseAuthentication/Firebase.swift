//
//  Firebase.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//
import SwiftUI
import Combine
import Foundation
import Firebase

class Firebase: ObservableObject {
    @Published var user: UserModel? {
        didSet {
            self.didChange.send(self)
        }}
    var didChange = PassthroughSubject<Firebase, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    
    
    
    
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if let user = user {
                print("Got user: \(user)")
                self.user = UserModel(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    photoURL: user.photoURL
                )
            } 
        }
    }
    func removeListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
}


