//
//  NewLoginView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 30/01/2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var firebase: Firebase
    @State var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "person.3.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding()
            
            TextField("Enter email", text: $loginViewModel.email)
                .modifier(LoginTextField())
            
            SecureField("Enter password", text: $loginViewModel.password)
                .modifier(LoginTextField())
            
            if loginViewModel.registerNewUser{
                SecureField("Confirm password", text: $loginViewModel.confirmPassword)
                    .modifier(LoginTextField())
                
                Button(action: {
                    loginViewModel.registerNewUser = false
                    loginViewModel.confirmPassword.removeAll()
                }
                , label: {
                    Text("Already have account?")
                    Text("Sign in!")
                        .fontWeight(.bold)
                })
                
                Button("SIGN UP"){
                    loginViewModel.signUp()
                }
                .modifier(ButtonModifier())
                .padding(.top, 20)
                
                
                
            } else {
                Button(action: {
                    loginViewModel.registerNewUser = true
                }
                , label: {
                    Text("Don't have account yet?")
                    Text("Sign up!")
                        .fontWeight(.bold)
                })
                
                Button("SIGN IN"){
                    loginViewModel.signIn()
                }
                .modifier(ButtonModifier())
                .padding(.top, 20)
            }
            
            
            if !loginViewModel.error.isEmpty {
                Text("\(loginViewModel.error)")
                    .padding()
                    .frame(width: 300, alignment: .center)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding()
                    .animation(.easeIn(duration: 2))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}






struct LoginTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(30)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 110, height: 45, alignment: .center)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(30)
    }
}


