//
//  LaunchPage.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import SwiftUI

struct LaunchPage: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @State private var isLoadingDefaults: Bool = false

    var body: some View {
            NavigationStack {
                ZStack {
                    VStack(spacing: 0) {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 280, alignment: .center)
                            .padding(.bottom, 30)
                        Text("Exam Genius BETA")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        ProgressView()
                            .foregroundStyle(.teal)
                            .scaleEffect(2)
                            .padding(25)
                            .opacity(isLoadingDefaults ? 1 : 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Image("Logo")
                            .offset(x: 160, y: 40)
                            .blur(radius: 100)
                    )
                }
            }
            .task {
                loadUserDefaults()
            }
    }
    
    private func loadUserDefaults() {
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoadingDefaults.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                isLoadingDefaults.toggle()
                appState.currentState = .signIn
            }
        }
    }
}





#Preview {
    let user = User()
    let appState = AppState()
    return LaunchPage()
        .environmentObject(user)
        .environmentObject(appState)
        .preferredColorScheme(.dark)
}

