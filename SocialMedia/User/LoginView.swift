//
//  NewLoginView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 30/01/2021.
//

import SwiftUI
import Firebase
import FirebaseAuth
import AuthenticationServices
import CoreHaptics

struct LoginView: View {
    @State private var hapticFeedback = UINotificationFeedbackGenerator()
    @EnvironmentObject var postsViewModel: PostsViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firebase: Firebase
    @StateObject var loginViewModel = LoginViewModel()
    @State var currentNonce:String?
   
  
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer(minLength: 150)
                    Image("logo")
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
                        .padding(.bottom, 20)
                        
                        Button(action: {
                            loginViewModel.signIn()
                        }, label: {
                            HStack {
                                Image(systemName: "envelope")
                                Text("Sign in with Email")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        })
                        .modifier(ButtonModifier())
                        .padding(.top, 20)
                    }
                    
                    SignInWithAppleButton(.signIn,
                                          onRequest: { request in
                                            let nonce = firebase.randomNonceString()
                                            currentNonce = nonce
                                            request.requestedScopes = [.fullName, .email]
                                            request.nonce = firebase.sha256(nonce)
                                          },
                                          onCompletion: { result in
                                            switch result {
                                            case .success(let authResults):
                                                self.hapticFeedback.notificationOccurred(.success)
                                                loginViewModel.isLoading = true
                                                switch authResults.credential {
                                                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                                    
                                                    guard let nonce = currentNonce else {
                                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                                    }
                                                    guard let appleIDToken = appleIDCredential.identityToken else {
                                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                                    }
                                                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                                        return
                                                    }
                                                    
                                                    let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                                        if (error != nil) {
                                                            // Error. If error.code == .MissingOrInvalidNonce, make sure
                                                            // you're sending the SHA256-hashed nonce as a hex string with
                                                            // your request to Apple.
                                                            print(error?.localizedDescription as Any)
                                                            return
                                                        }
                                                        loginViewModel.isLoading = false
                                                        print("signed in")
                                                    }
                                                    
                                                    print("\(String(describing: Auth.auth().currentUser?.uid))")
                                                default:
                                                    break
                                                    
                                                }
                                            default:
                                                break
                                            }
                                          })
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 280, height: 50, alignment: .center)
                  
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
                    
                    Spacer()
                    
                    
                        .padding(.bottom, 50)
                    
                }
                
                if loginViewModel.isLoading {
                    ZStack{
                        Color(colorScheme == .dark ? .black : .white).opacity(0.7)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                   
                    
                }
            }
        }.edgesIgnoringSafeArea(.all)
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
            .cornerRadius(10)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 280, height: 50, alignment: .center)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
    }
}


