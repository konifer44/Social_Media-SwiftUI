//
//  PostModelView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 04/02/2021.
//
import SwiftUI
import Foundation
import FirebaseDatabase
import Combine

class PostsViewModel: ObservableObject {
    @Published var posts: [PostModel] = [] { willSet { objectWillChange.send()}}
    @Published var addPostIsPresented = false
    @Published var newPost: PostModel = PostModel(userID: "", message: "", likes: 0)
    
    var databaseReference: DatabaseReference!
    
    init(){
        databaseReference = Database.database().reference()
    }
    
    func removePost(postID: String, userID: String){
        databaseReference.child(postID).removeValue() { error, handler  in
            DispatchQueue.main.async {
                for post in self.posts {
                    if post.postID == postID {
                        if let postIndex = self.posts.firstIndex(of: post) {
                            self.posts.remove(at: postIndex)
                        }
                    }
                }
            }
            
        }
    }
    
    func fetchData(){
        databaseReference.observe(.value, with: { snapshot in
            var fetchedPosts: [PostModel] = []
            for child in snapshot.children {
               print(snapshot)
                if let snapshot = child as? DataSnapshot,
                   let post = PostModel(snapshot: snapshot) {
                    fetchedPosts.append(post)
                }
            }
            DispatchQueue.main.async {
                self.posts = fetchedPosts.sorted(by: {$0.creationTime! > $1.creationTime!})
                
            }
        })
        
    }
    
    func like(postID: String, userID: String) {
        print("like")
        let postReference = databaseReference.child(postID)
        
        postReference.observeSingleEvent(of: .value, with: { snapshot in
            guard let post = PostModel(snapshot: snapshot) else { return }
            for liked in post.likedBy {
                if liked.value == userID {
                    let likes = post.likes - 1
                    postReference.child("likedBy").child(liked.key).removeValue()
                    postReference.updateChildValues(["likes" : likes])
                    return
                }
            }
            let likes = post.likes + 1
            postReference.child("likedBy").childByAutoId().setValue(userID)
            postReference.updateChildValues(["likes" : likes])
        })
    }
    
    func isLikedByCurrentUser(userID: String, postID: String, isLiked: @escaping ((Bool) -> Void)) {
        databaseReference.child(postID).observeSingleEvent(of: .value, with: { snapshot in
            guard let post = PostModel(snapshot: snapshot) else { return }
            for liked in post.likedBy {
                if liked.value == userID {
                    isLiked(true)
                }
            }
        })
    }
    
    func uploadData(userID: String){
        self.newPost.creationTime = Int(Date().timeIntervalSince1970)
        self.newPost.userID = userID
        let postRef = databaseReference.child(newPost.postID)
        postRef.setValue(toAnyObject(post: newPost)) { error, databaseReference in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                
            }
        }
        self.addPostIsPresented = false
        self.newPost = PostModel(userID: "", message: "", likes: 0)
        
    }
    
    func toAnyObject(post: PostModel) -> Any {
        return [
            "postID" : post.postID,
            "creationTime" : post.creationTime ?? 0,
            "userID" : post.userID,
            "message" : post.message,
            "likes" : post.likes,
            "likedBy" : post.likedBy
        ]
    }
}



struct PostModel: Hashable{
    var creationTime: Int?
    let postID: String
    var userID: String
    var message: String
    var likes: Int
    var likedBy: [String : String]
    
    init(userID: String, message: String, likes: Int){
        self.postID =  UUID().uuidString
        self.userID = userID
        self.message = message
        self.likes = likes
        self.likedBy = [" " : " "]
    }
    
    
    init?(snapshot: DataSnapshot){
        guard
            let post = snapshot.value as? [String: Any],
            let creationTime = post["creationTime"] as? Int,
            let postID = post["postID"] as? String,
            let userID = post["userID"] as? String,
            let message = post["message"] as? String,
            let likes = post["likes"] as? Int,
            let likedBy = post["likedBy"] as? [String : String]
        else {
            print("Could not parse data")
            return nil
        }
        self.creationTime = creationTime
        self.postID = postID
        self.userID = userID
        self.message = message
        self.likes = likes
        self.likedBy = likedBy
    }
}
