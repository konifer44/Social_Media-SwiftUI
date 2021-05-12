//
//  UserSettingsTabView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI
import Firebase


struct UserSettingsView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var firebase: Firebase
    // @ObservedObject var userViewModel = UserViewModel()
    
    @State private var timeRemaining = 0.0
    @State private var showImagePicker = false
    @State private var error: String = ""
    @State private var timeOut = false
    @State private var editName = false
    @State private var temporaryName = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack{
                    Spacer()
                    Button("Logout"){
                        postsViewModel.posts.removeAll()
                        firebase.signOut()
                    }
                    .padding()
                    .disabled(firebase.isUploading)
                }
                
                VStack{
                    ZStack{
                        Circle()
                            .strokeBorder(Color(.systemGray5),lineWidth: 4)
                            .frame(width: 185, height: 185, alignment: .center)
                        
                        if firebase.isUploading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        } else {
                            if firebase.userImageToDisplay == nil{
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.white)
                            } else {
                                firebase.userImageToDisplay?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 170, height: 170, alignment: .center)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    Button(action: {
                        showImagePicker = true
                    },label: {
                        Text("\(firebase.userImageToUpload == nil ? "Upload Image" : "Change Image")")
                    })
                    .sheet(isPresented: $showImagePicker){ ImagePicker(image: $firebase.userImageToUpload) }
                }
                .frame(height: geometry.size.height / 3, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom:50, trailing: 0))
                
                
                HStack{
                    Text("Email")
                        .frame(width: 100, alignment: .leading)
                    
                    Text("\((firebase.user?.email) ?? "User Email")")
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.02)
                        .lineLimit(1)
                        .padding(0)
                    Spacer()
                }
                .padding()
                Divider()
                
                if editName {
                    HStack{
                        Text("User name")
                            .frame(width: 100, alignment: .leading)
                        if editName {
                            TextField((firebase.user!.displayName?.isEmpty ?? false ? "Enter name" : firebase.user!.displayName) ?? "Enter name", text: $temporaryName)
                        }
                        Spacer()
                        
                        Button(action: {
                            editName = false
                            firebase.updateUserName(newName: temporaryName)
                        }, label: {
                            Text("Done")
                        })
                    }
                    .padding()
                    
                    
                } else {
                    
                    HStack{
                        Text("User name")
                            .frame(width: 100, alignment: .leading)
                        
                        Text(firebase.user?.displayName ?? "No user name")
                        Spacer()
                        
                        Button(action: {
                            editName = true
                        }, label: {
                            Text("Edit")
                        })
                    }
                    .padding()
                    
                }
                Divider()
                
                HStack{
                    Text("Bio")
                        .frame(width: 100, alignment: .leading)
                    Text(loremIpsum)
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear(){
            firebase.downloadImage()
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
            .environmentObject(PostsViewModel())
            .environmentObject(Firebase())
    }
}

