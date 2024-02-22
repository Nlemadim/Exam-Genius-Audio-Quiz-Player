//
//  CustomNavBar.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/22/24.
//

import Foundation
import SwiftUI

struct CustomNavBar: View {
    var categories: [String]
    @State private var selectedCategory = "One"
    var body: some View {
        HStack {
            Spacer()
            // Profile picture
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.teal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            self.selectedCategory = category
                        }) {
                            Text(category)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(self.selectedCategory == category ? Color.teal : Color.gray.opacity(0.2))
                                .foregroundColor(self.selectedCategory == category ? .black : .white)
                                .cornerRadius(18)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 20)
                .padding(.all, 20.0)
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollTargetLayout()
            //.containerRelativeFrame(.horizontal)
            
           // Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top)
        .background(Color.black)
    }
}
