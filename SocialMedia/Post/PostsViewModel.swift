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
    @Published var posts: [PostModel] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var addPostIsPresented = false
    @Published var newPost: PostModel = PostModel(userID: "", userName: "", userPhotoURL: "", message: "", likes: 0)
    @Published var userImageToDisplay: Image?
    
    var databaseReference: DatabaseReference!
    var documentURL: URL
    
    init(){
        databaseReference = Database.database().reference()
        documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    lazy var cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")
        let cache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
        return cache
    }()
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()
    
    func unwrappImage(data: Data) -> Image? {
        if let uiImage = UIImage(data: data){
            return Image(uiImage: uiImage)
        } else {
            return  nil
        }
    }
    
    func removePost(postID: String){
        databaseReference.child(postID).removeValue() { error, handler  in }
        removeLikeObserver(postID: postID)
    }
    
    func fetchData(){
        print("fetchData")
        databaseReference.getData(){ error, snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    self.downloadPostWithUserImage(snapshot: snapshot)
                }
            }
            //DispatchQueue.main.async {
                self.posts.sort{$0.creationTime! > $1.creationTime!}
           // }
        }
    }
    
    func observeForNewPosts(){
        print("observeForNewPosts")
        guard let postReference = databaseReference else { return }
        postReference.observe(.childAdded) { snapshot in
            self.downloadPostWithUserImage(snapshot: snapshot)
        }
      //  DispatchQueue.main.async {
            self.posts.sort{$0.creationTime! > $1.creationTime!}
      //  }
    }
    
    func observeForRemovedPosts(){
        print("observeForRemovedPosts")
        guard let postReference = databaseReference else { return }
        postReference.observe(.childRemoved) { snapshot in
            let postID = snapshot.key
            for post in self.posts {
                if post.postID == postID {
                    if let postIndex = self.posts.firstIndex(of: post) {
                        self.posts.remove(at: postIndex)
                        return
                    }
                }
            }
        }
    }
    
    func observeForNewLikes(postID: String) {
        print("observeForNewLikes")
        let postReference = databaseReference.child(postID).child("likes")
        postReference.observe(.value) { snapshot in
            guard let newLikes = snapshot.value as? Int else { return }
            DispatchQueue.main.async {
                for post in self.posts {
                    if post.postID == postID {
                        if let postIndex = self.posts.firstIndex(of: post) {
                            self.posts[postIndex].likes = newLikes
                        }
                    }
                }
            }
        }
    }
    
    func removeLikeObserver(postID: String){
        print("remove like observer at: \(postID)")
        let postReference = databaseReference.child(postID).child("likes")
        postReference.removeAllObservers()
    }
    
    func removeAllObservers(){
        for post in posts {
            let postReference = databaseReference.child(post.postID).child("likes")
            print("remove like observer at: \(post.postID)")
            postReference.removeAllObservers()
        }
        databaseReference.removeAllObservers()
    }
    
    func likePost(post: PostModel, by userID: String){
        for downloadedPost in self.posts {
            if downloadedPost.postID == post.postID {
                    let postReference = databaseReference.child(post.postID)
                    postReference.observeSingleEvent(of: .value) { snapshot in
                        guard let downloadedPost = PostModel(snapshot: snapshot) else { return }
                        for liked in downloadedPost.likedBy {
                            if liked.value == userID {
                                let likes = downloadedPost.likes - 1
                                postReference.child("likedBy").child(liked.key).removeValue()
                                postReference.updateChildValues(["likes" : likes])
                                return
                            }
                        }
                        let likes = downloadedPost.likes + 1
                        postReference.child("likedBy").childByAutoId().setValue(userID)
                        postReference.updateChildValues(["likes" : likes])
                    }
            }
        }
    }
    
    func isLikedByCurrentUser(post: PostModel, by userID: String){
        print("isliked")
        for downloadedPost in self.posts {
            if downloadedPost.postID == post.postID {
                if let postIndex = self.posts.firstIndex(of: post) {
                    let postReference = databaseReference.child(post.postID)
                    postReference.observe(.value) { snapshot in
                        guard let newDownloadedPost = PostModel(snapshot: snapshot) else { return }
                        DispatchQueue.main.async {
                            for liked in newDownloadedPost.likedBy {
                                if liked.value == userID {
                                    print("found pair")
                                    self.posts[postIndex].isLikedByCurrentUser = true
                                    return
                                } else {
                                    
                                    print("not pair")
                                }
                            }
                            self.posts[postIndex].isLikedByCurrentUser = false
                        }
                    }
                }
            }
        }
    }
    
    func downloadPostWithUserImage(snapshot: DataSnapshot){
        guard var post = PostModel(snapshot: snapshot) else { return }
        if let userPhotoURL = URL(string: post.userPhotoURL) {
            let targetURL = self.documentURL.appendingPathComponent(userPhotoURL.lastPathComponent)
            let request = URLRequest(url: userPhotoURL, cachePolicy: .returnCacheDataElseLoad)
            
            if let data = try? Data(contentsOf: userPhotoURL) {
                DispatchQueue.main.async {
                    post.userPhoto = self.unwrappImage(data: data)
                    self.posts.append(post)
                    self.posts.sort{$0.creationTime! > $1.creationTime!}
                }
            } else {
                let downloadTask = self.session.downloadTask(with: request) { url, response, error in
                    if let response = response, let url = url,
                       self.cache.cachedResponse(for: request) == nil,
                       let data = try? Data(contentsOf: url, options: [.mappedIfSafe]){
                        self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                        DispatchQueue.main.async {
                            post.userPhoto = self.unwrappImage(data: data)
                            self.posts.append(post)
                            self.posts.sort{$0.creationTime! > $1.creationTime!}
                        }
                    }
                    guard let tempURL = url else { return }
                    _ = try? FileManager.default.replaceItemAt(targetURL, withItemAt: tempURL)
                }
                downloadTask.resume()
            }
        } else {
            self.posts.append(post)
            self.posts.sort{$0.creationTime! > $1.creationTime!}
        }
    }
    
    func uploadData(userID: String, userName: String, userPhotoURL: URL?){
        self.newPost.creationTime = Int(Date().timeIntervalSince1970)
        self.newPost.userID = userID
        self.newPost.userPhotoURL = userPhotoURL?.absoluteString ?? ""
        self.newPost.userName = userName
        let postRef = databaseReference.child(newPost.postID)
        postRef.setValue(toAnyObject(post: newPost)) { error, databaseReference in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
            }
        }
        self.addPostIsPresented = false
        self.newPost = PostModel(userID: "", userName: "", userPhotoURL: "", message: "", likes: 0)
    }
    
    func toAnyObject(post: PostModel) -> Any {
        return [
            "postID" : post.postID,
            "creationTime" : post.creationTime ?? 0,
            "userID" : post.userID,
            "userName" : post.userName,
            "userPhotoURL" : post.userPhotoURL,
            "message" : post.message,
            "likes" : post.likes,
            "likedBy" : post.likedBy
        ]
    }
}



struct PostModel: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(creationTime)
        hasher.combine(postID)
        hasher.combine(userName)
        hasher.combine(userID)
        hasher.combine(userPhotoURL)
        hasher.combine(message)
        hasher.combine(likes)
        hasher.combine(likedBy)
    }
    
    var creationTime: Int?
    let postID: String
    var userID: String
    var userName: String
    var userPhotoURL: String
    var userPhoto: Image?
    var message: String
    var likes: Int
    var likedBy: [String : String]
    var isLikedByCurrentUser = false
   
    init(userID: String, userName: String, userPhotoURL: String, message: String, likes: Int){
        self.postID =  UUID().uuidString
        self.userID = userID
        self.userName = userName
        self.userPhotoURL = userPhotoURL
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
                    let userName = post["userName"] as? String,
                    let userPhotoURL = post["userPhotoURL"] as? String,
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
        self.userName = userName
        self.userPhotoURL = userPhotoURL
        self.message = message
        self.likes = likes
        self.likedBy = likedBy
    }
}
