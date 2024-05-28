//
//  QuizPlayerDetails.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 5/3/24.
//

import SwiftUI

struct QuizPlayerDetails: View {
    @Environment(\.dismiss) private var dismiss
    @State var currentPage: String = "Summary"
    @Binding var didTapEdit: Bool
    //For Smooth Page Sliding Effect
    @Namespace var animation
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView()
                
                
                //MARK: Pinned Header With Content
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        if currentPage == "Summary" {
                            SummaryInfoView(highScore: 3, numberOfTestsTaken: 10)
                                .padding()
                            
                        }
                        
                    } header: {
                        PinnedHeaderView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: {
            didTapEdit = true
        })
        .onDisappear(perform: {
            didTapEdit = false
        })
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.container, edges: .vertical)
        .coordinateSpace(name: "SCROLL")
        
        customBackButton
            .frame(alignment: .bottom)
            .padding()

    }
    
    // Custom back button
    private var customBackButton: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "x.circle")
                Text("Dismiss")
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Image("AmericanHistory-Exam")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: height, alignment: .top)
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                       
                        //Dimming out text Content
                        LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.5),
                            .black.opacity(0.9)
                        ], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .bottom, spacing: 10) {
                                Text("Audio Quiz")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                
                                Image(systemName: "headphones")
                                    .foregroundStyle(.gray)
                            }
                            
                            Text("American History")
                                .font(.title.bold())
                                .primaryTextStyleForeground()
                            
                            Label {
                                
                                Text("Activity Summary")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white.opacity(0.7))
                                
                            } icon: {
                                
                                
                            }
                            .font(.caption)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                })
                .cornerRadius(15)
                .offset(y: -minY)
                
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let pages: [String] = ["Summary", "Core Topics", "Q&A"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                
                ForEach(pages, id: \.self) { page in
                    VStack(spacing: 12) {
                        
                        Text(page)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(currentPage == page ? .white : .gray)
                        
                        ZStack {
                            if currentPage == page {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentPage = page
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 25)
        }
        
    }
}

#Preview {
    QuizPlayerDetails(didTapEdit: .constant(false))
        .preferredColorScheme(.dark)
}
