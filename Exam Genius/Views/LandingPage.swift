//
//  LandingPage.swift
//  Exam Genius Audio Quiz Player BETA
//
//  Created by Tony Nlemadim on 2/16/24.
//

import SwiftUI

struct LandingPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack {
                    
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.teal)
                    }
                }
                .background(
                    Image("Logo")
                        .offset(x: 230, y: -100)
                )
            }
            .tabItem {
                TabIcons(title: "Home", icon: "house.fill")
            }
            .tag(0)
            
        }
        .tint(.teal)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.black
        }
    }
}

#Preview {
    LandingPage()
        .preferredColorScheme(.dark)
        .modelContainer(for: [AudioQuizPackage.self, Topic.self, Question.self, Performance.self], inMemory: true)
}
