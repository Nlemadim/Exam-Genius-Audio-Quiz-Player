//
//  CustomNavigationBar.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/27/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var categories: [ExamCategory]
    @Binding var selectedCategory: ExamCategory?
    
    var body: some View {
        HStack {
            // Profile picture always on the left
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.teal)
                .padding(.leading)
            
            Spacer()
            
            // Categories
            if selectedCategory == nil {
                // Show all categories if none is selected
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            categoryButton(category: category)
                        }
                    }
                    .padding(.vertical, 8)
                    
                }
                .frame(maxWidth: .infinity, alignment: .top)
                
            } else {
                HStack {
                    // Show only the selected category with an option to deselect
                    categoryButton(category: selectedCategory!)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .frame(height: 80)
        .background(Color.black)
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private func categoryButton(category: ExamCategory) -> some View {
        Button(action: {
            // Toggle selection state on double-tap
            if self.selectedCategory == category {
                self.selectedCategory = nil // Deselect if the same category is tapped again
            } else {
                self.selectedCategory = category
            }
        }) {
            HStack {
                Text(category.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                // Show "xmark.circle.fill" next to the category name if it's the selected category
                if self.selectedCategory == category {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            // Change the background color based on selection state
            .background(self.selectedCategory == category || self.selectedCategory == nil ? LinearGradient(gradient: Gradient(colors: [.themePurpleLight, .themePurple]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .top, endPoint: .bottom))
            .foregroundColor(self.selectedCategory == category || self.selectedCategory == nil ? .white : .secondary)
            .cornerRadius(18)
        }
        .opacity(self.selectedCategory == nil || self.selectedCategory == category ? 1 : 0)
        .shadow(color: .gray, radius: 1)
        .transition(.scale)
    }

}

struct CustomNavigationBar2: View {
    var categories: [ExamCategory]
    @Binding var selectedCategory: ExamCategory?
    
    var body: some View {
        VStack {
            Spacer().frame(height: 8) // Add spacer to simulate a larger navigation bar
            
            HStack {
                // Profile picture always on the left
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.teal)
                
                Spacer()
                
                // Categories
                if selectedCategory == nil {
                    // Show all categories if none is selected
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                categoryButton(category: category)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                } else {
                    HStack {
                        // Show only the selected category with an option to deselect
                        categoryButton(category: selectedCategory!)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            //.padding([.leading, .trailing], 16) // Add padding on the sides for better alignment of content
            
            Spacer().frame(height: 8) // Additional spacer at the bottom for visual balance
        }
        .background(Color.black.edgesIgnoringSafeArea(.top)) // Ensure the background extends to the top edge of the screen
        .frame(height: 70) // Adjusted frame height for the navigation bar
    }
    
    private func categoryButton(category: ExamCategory) -> some View {
        Button(action: {
            // Toggle selection state on double-tap
            if self.selectedCategory == category {
                self.selectedCategory = nil // Deselect if the same category is tapped again
            } else {
                self.selectedCategory = category
            }
        }) {
            HStack {
                Text(category.rawValue)
                    .font(.callout)
                    .fontWeight(.medium)
                // Show "xmark.circle.fill" next to the category name if it's the selected category
                if self.selectedCategory == category {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            // Change the background color based on selection state
            .background(self.selectedCategory == category || self.selectedCategory == nil ? LinearGradient(gradient: Gradient(colors: [.themePurpleLight, .themePurple]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .top, endPoint: .bottom))
            .foregroundColor(self.selectedCategory == category || self.selectedCategory == nil ? .white : .secondary)
            .cornerRadius(18)
        }
        .opacity(self.selectedCategory == nil || self.selectedCategory == category ? 1 : 0)
        .shadow(color: .gray, radius: 1)
        .transition(.scale)
    }
    
}

//#Preview {
//    @State var selectedCategory: ExamCategory? = nil
//    return CustomNavigationBar2(categories: ExamCategory.allCases, selectedCategory: $selectedCategory)
//        //.preferredColorScheme(.dark)
//}
#Preview {
    @State var selectedCategory: ExamCategory? = nil
    return CustomNavigationBar(categories: ExamCategory.allCases, selectedCategory: $selectedCategory)
        //.preferredColorScheme(.dark)
}
