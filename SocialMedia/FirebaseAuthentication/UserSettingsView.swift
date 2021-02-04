//
//  UserSettingsTabView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI

struct UserSettingsView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack{
                VStack{
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 150))
                        .foregroundColor(Color(.systemGray5))
                        .background(Color(.systemGray4))
                        .clipShape(Circle())
                        .padding(8)
                    Button("Upload Image") {
                        
                    }
                }
                .frame(height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(EdgeInsets(top: 50, leading: 0, bottom:50, trailing: 0))
                
                HStack{
                    Text("Email")
                        .frame(width: 120, alignment: .leading)
                    Text("Jan")
                    
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
        }.edgesIgnoringSafeArea(.all)
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}

