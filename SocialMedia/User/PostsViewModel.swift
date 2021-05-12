//
//  PostModelView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 04/02/2021.
//
import SwiftUI
import Foundation
import FirebaseDatabase

class PostViewModel: ObservableObject {
    @Published var post: PostModel
    @EnvironmentObject var firebase: Firebase
    
    var databaseReference: DatabaseReference!
    
    init(with post: PostModel){
        self.post = post.self
        databaseReference = Database.database().reference()
    }
    
    
    
    
    func fetchData(){
           }
    
    func uploadData(){
        guard let userUID = firebase.user?.uid else { return }
        self.databaseReference.child("posts").child(userUID)
    }
    
    
    
    
    
    
    func toAnyObject(post: PostModel) -> Any {
        return [
            "userUID" : post.userUID,
            "title" : post.title,
            "message" : post.message,
            "likes" : post.likes
        ]
    }
    
    
}



struct PostModel {
    let userUID: String
    let title: String
    let message: String
    let likes: Int
}
