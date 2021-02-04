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
import FirebaseStorage

class Firebase: ObservableObject {
    @Published var user: UserModel? { didSet { self.didChange.send(self) }}
    @Published var userImageToUpload: UIImage? {
        didSet {
            uploadImage()
            userImageToDisplay = Image(uiImage: userImageToUpload!)
        }
    }
    @Published var userImageToDisplay: Image?
    @Published var isUploading = false
    
    let storage = Storage.storage()
    var didChange = PassthroughSubject<Firebase, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
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
    
    func uploadImage(){
        
        guard let user = user else { return }
        guard let userImageToUpload = userImageToUpload else { return }
        guard let imageData = userImageToUpload.jpegData(compressionQuality: 0.1) else { return }
        
        self.isUploading = true
        storage.reference().child(user.uid).putData(imageData, metadata: nil) { metadata , error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.storage.reference(withPath: user.uid).downloadURL() { url, error in
                if let url = url {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = url
                    changeRequest?.commitChanges(){ error in
                        print(error?.localizedDescription as Any)
                    }
                    self.isUploading = false
                }
            }
        }
    }
    
    func downloadImage(){
        guard let user = user else { return }
        guard let userPhotoURL = user.photoURL else { return }
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let targetURL = documentURL.appendingPathComponent(userPhotoURL.lastPathComponent)
        
        let request = URLRequest(url: userPhotoURL, cachePolicy: .returnCacheDataElseLoad)
        if let data = try? Data(contentsOf: userPhotoURL) {
            DispatchQueue.main.async {
                self.userImageToDisplay = Image(uiImage: UIImage(data: data)!)
            }
        }
        let downloadTask = session.downloadTask(with: request) { url, response, error in
            if let response = response, let url = url,
               self.cache.cachedResponse(for: request) == nil,
               let data = try? Data(contentsOf: url, options: [.mappedIfSafe]){
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                print("download4")
                DispatchQueue.main.async {
                        if let uiImage = UIImage(data: data){
                            self.userImageToDisplay = Image(uiImage: uiImage)
                        } else {
                            self.userImageToDisplay = nil
                        }    
                }
            }
            guard let tempURL = url else { return }
            _ = try? FileManager.default.replaceItemAt(targetURL, withItemAt: tempURL)
        }
        downloadTask.resume()
    }
    
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
                self.downloadImage()
            } 
        }
    }
    func removeListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func signOut () {
        try? Auth.auth().signOut()
        self.user = nil
        self.cache.removeAllCachedResponses()
    }
}





struct UserModel {
    var uid: String
    var email: String?
    var displayName: String?
    var photoURL: URL?
    
    init(uid: String, displayName: String?, email: String?, photoURL: URL?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }
}
