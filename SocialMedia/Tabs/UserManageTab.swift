//
//  LoginView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI

struct UserManageTab: View {
    @StateObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var firebase: Firebase
    
    var body: some View {
        
        if firebase.user != nil {
           UserSettingsTabView()
        } else {
            VStack {
                if loginViewModel.registerNewUser{
                    RegisterSubview()
                        .environmentObject(loginViewModel)
                } else {
                    LoginSubview()
                        .environmentObject(loginViewModel)
                }
                
                if !loginViewModel.error.isEmpty {
                    LoginErrorView()
                        .environmentObject(loginViewModel)
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}








private struct LoginSubview: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
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
    }
}


private struct RegisterSubview: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
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
            
            SecureField("Confirm password", text: $loginViewModel.confirmPassword)
                .modifier(LoginTextField())
            
            
            Button(action: {
                loginViewModel.registerNewUser = false
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
            
        }
        .onDisappear(){
            loginViewModel.confirmPassword.removeAll()
        }
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


struct LoginErrorView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
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



