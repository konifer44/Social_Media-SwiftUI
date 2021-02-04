//
//  UserSettingsTabView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI
import Firebase


struct UserSettingsView: View {
    @EnvironmentObject var firebase: Firebase
    // @ObservedObject var userViewModel = UserViewModel()
    
    @State private var timeRemaining = 0.0
    @State private var showImagePicker = false
    @State private var error: String = ""
    @State private var timeOut = false
   
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack{
                    Spacer()
                    Button("Logout"){
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
                        } else {
                            firebase.userImageToDisplay?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 170, height: 170, alignment: .center)
                                .clipShape(Circle())
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
                        .frame(width: 120, alignment: .leading)
                    Text("\((firebase.user?.email) ?? "User Email")")
                    
                    Spacer()
                }
                .padding()
                Divider()
                
                HStack{
                    Text("Last Name")
                        .frame(width: 120, alignment: .leading)
                    Text("Konieczny")
                    Spacer()
                }
                .padding()
                Divider()
                
                HStack{
                    Text("Email")
                        .frame(width: 120, alignment: .leading)
                    Text("emailExample@email.com")
                    Spacer()
                }
                .padding()
                Divider()
                
                HStack{
                    Text("Bio")
                        .frame(width: 120, alignment: .leading)
                    Text("")
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
    }
}

