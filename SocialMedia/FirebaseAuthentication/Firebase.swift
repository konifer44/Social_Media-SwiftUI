//
//  Firebase.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//
import SwiftUI
import Combine
import Foundation
import CryptoKit
import FirebaseAuth
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
                self.unwrappImage(data: data)
            }
        }
        let downloadTask = session.downloadTask(with: request) { url, response, error in
            if let response = response, let url = url,
               self.cache.cachedResponse(for: request) == nil,
               let data = try? Data(contentsOf: url, options: [.mappedIfSafe]){
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                print("download4")
                DispatchQueue.main.async {
                    self.unwrappImage(data: data)
                }
            }
            guard let tempURL = url else { return }
            _ = try? FileManager.default.replaceItemAt(targetURL, withItemAt: tempURL)
        }
        downloadTask.resume()
    }
    
    func unwrappImage(data: Data){
        if let uiImage = UIImage(data: data){
            self.userImageToDisplay = Image(uiImage: uiImage)
        } else {
            self.userImageToDisplay = nil
        }
        
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
    
    
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
            }.joined()

            return hashString
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
