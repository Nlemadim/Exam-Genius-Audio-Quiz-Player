//
//  SignInPage.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import SwiftUI

struct SignInPage: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn: Bool = false

    var body: some View {
        NavigationStack {
            TabView {
                // Slide 1
                VStack(spacing: 10) {
                    Spacer()
                    Text("Practice!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    
                    Text("Choose from over 200 multichoice audio exams and answer questions totally hands-free.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .padding()

                // Slide 2
                VStack(spacing: 10) {
                    Spacer()
                    Text("Build!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    Text("Drill down on specific topics from your practice exams and build an audio quiz specific to that topic.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .padding()

                // Slide 3
                VStack(spacing: 10) {
                    Spacer()
                    Text("Learn!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.yellow)
                    Text("Every failed question presents a learning opportunity. Turn on Learning mode AI will create an audio note delivered in an engaging way designed to teach you all you need to know regarding context of the question relative to the topic.")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .padding()

                // Sign-in Slide
                VStack(spacing: 5) {
                    Text("Sign-up and get access to unlimited questions carefully curated and continuously refined by AI to stay relevant to you and the knowledge you seek.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .preferredColorScheme(.light)
                        //.padding()
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .preferredColorScheme(.light)
                    
                    Button("Sign In as Guest") {
                       signInProcess()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.all, 7.0)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ProgressView()
                        .foregroundStyle(.teal)
                        .scaleEffect(1)
                        .padding(25)
                        .padding(.bottom, 10)
                        .opacity(isSigningIn ? 1 : 0)
                    
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 370)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .background(
                Image("Logo")
                    .offset(x: 160, y: 40)
                    .blur(radius: 100)
            )
        }
        .navigationBarBackButtonHidden()
    }
    
    private func signInProcess() {
        UserDefaults.standard.set(true, forKey: "isSignedIn")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSigningIn.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                user.isSignedIn = true
                isSigningIn.toggle()
                appState.currentState = .signedIn
            }
        }
    }
}


#Preview {
    let user = User()
    let appState = AppState()
    return SignInPage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
}
