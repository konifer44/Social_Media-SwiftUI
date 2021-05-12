//
//  PostModelView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 04/02/2021.
//

import Foundation
import FirebaseFirestoreSwift

class PostsModelView: ObservableObject {
    @Published var posts = []
    
    private var database = Firestore.firestore()
}



struct PostModel: Identifiable, Codable{
    @DocumentID var id: String? = UUID().uuidString
    let userID: String
    let title: String
    let message: String
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case userID
        case title
        case message
        case likes
    }
}
