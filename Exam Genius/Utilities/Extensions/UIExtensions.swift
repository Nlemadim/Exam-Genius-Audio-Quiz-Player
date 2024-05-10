//
//  UIExtensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import Foundation
import SwiftUI
//import UIKit

extension CGFloat {
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per;
        //screenWidth: 375 * 0.5
    }
    
    static func heightPer(per: Double) -> Double {
        return screenWidth * per;
        //screenWidth: 375 * 0.5
    }
}


extension UIScreen {
    static func widthPer(percentage: Double) -> CGFloat {
        return UIScreen.main.bounds.width * CGFloat(percentage / 100)
    }

    static func heightPer(percentage: Double) -> CGFloat {
        return UIScreen.main.bounds.height * CGFloat(percentage / 100)
    }
}


extension UIImage {
    func dominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: inputImage.extent)])
        guard let outputImage = filter?.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1)
    }
    
    func enhancedDominantColor() -> UIColor? {
        guard let dominantColor = self.dominantColor() else { return nil }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        dominantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [red, green, blue, alpha]
        if let cgColor = CGColor(colorSpace: colorSpace, components: components),
           let hsbColor = UIColor(cgColor: cgColor).hsbColor() {
            
            let enhancedSaturation = min(hsbColor.saturation * 1.3, 1.0)  // Increase saturation by 30%, cap at 100%
            let enhancedBrightness = min(hsbColor.brightness * 1.2, 1.0)  // Increase brightness by 20%, cap at 100%
            return UIColor(hue: hsbColor.hue, saturation: enhancedSaturation, brightness: enhancedBrightness, alpha: alpha)
        }

        return nil
    }
    
    func sharpContrastColor() -> UIColor? {
        guard let dominantColor = self.dominantColor() else { return nil }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        dominantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate brightness of the dominant color
        let brightness = 0.299 * red + 0.587 * green + 0.114 * blue
        
        // Return black or white for sharp contrast based on brightness
        return brightness > 0.5 ? UIColor.black : UIColor.white
    }
    
    func dominantDarkTone() -> UIColor? {
        guard let dominantColor = self.dominantColor() else { return nil }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        dominantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Adjust the color to a darker tone
        let darkerFactor: CGFloat = 0.55
        return UIColor(red: max(red - darkerFactor, 0), green: max(green - darkerFactor, 0), blue: max(blue - darkerFactor, 0), alpha: alpha)
    }
    
    func dominantLightTone() -> UIColor? {
        guard let dominantColor = self.dominantColor() else { return nil }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        dominantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Adjust the color to a lighter tone
        let lighterFactor: CGFloat = 0.45
        return UIColor(red: min(red + lighterFactor, 1), green: min(green + lighterFactor, 1), blue: min(blue + lighterFactor, 1), alpha: alpha)
    }
    
    func secondaryColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let overallDominantColor = self.dominantColor()
        
        // Divide the image into segments (e.g., quadrants)
        let segments = [CGRect(x: 0, y: 0, width: inputImage.extent.width / 2, height: inputImage.extent.height / 2),
                        CGRect(x: inputImage.extent.width / 2, y: 0, width: inputImage.extent.width / 2, height: inputImage.extent.height / 2),
                        CGRect(x: 0, y: inputImage.extent.height / 2, width: inputImage.extent.width / 2, height: inputImage.extent.height / 2),
                        CGRect(x: inputImage.extent.width / 2, y: inputImage.extent.height / 2, width: inputImage.extent.width / 2, height: inputImage.extent.height / 2)]
        
        var secondaryColor: UIColor?
        var maxDifference: CGFloat = 0
        
        for segment in segments {
            let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: segment)])
            guard let outputImage = filter?.outputImage else { continue }
            
            var bitmap = [UInt8](repeating: 0, count: 4)
            let context = CIContext(options: nil)
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: nil)
            
            let segmentColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1)
            
            // Compare this segment's dominant color to the overall dominant color
            if let overallDominantColor = overallDominantColor, let difference = colorDifference(color1: overallDominantColor, color2: segmentColor), difference > maxDifference {
                maxDifference = difference
                secondaryColor = segmentColor
            }
        }
        
        return secondaryColor
    }
    
    // Helper method to calculate the difference between two colors
    private func colorDifference(color1: UIColor, color2: UIColor) -> CGFloat? {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        
        guard color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1),
              color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2) else { return nil }
        
        // Simple Euclidean distance for color difference, can be adjusted as needed
        return sqrt(pow(red2 - red1, 2) + pow(green2 - green1, 2) + pow(blue2 - blue1, 2))
    }
    
}

extension View {
    func dynamicExactGradientBackground(startColor: Color, endColor: Color) -> some View {
        let startPoint = UnitPoint(x: 0.49999998837676157, y: 2.9479518284275417e-15)
        let endPoint = UnitPoint(x: 0.4999999443689973, y: 0.9363635917143408)
        
        return self.background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                                              startPoint: startPoint,
                                              endPoint: endPoint))
    }
    
    func primaryTextStyleForeground() -> some View {
        self.foregroundStyle(
            LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as?
                         UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            
            return 0
        }
        
        return 0
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func activeGlow(_ color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
    }
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func labelStyle() -> some View {
        self
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
    }
    
    func scoreStyle() -> some View {
        self
            .foregroundStyle(.themePurple)
            .font(.system(size: 18))
            .fontWeight(.bold)
    }
    
    func backgroundStyle() -> some View {
        self
            .padding()
            .background(Color.gray.opacity(0.06))
    }
    
    func lightBackgroundStyle() -> some View {
        self.background(
            Circle()
                .fill(Material.ultraThin)
                .environment(\.colorScheme, .light)
        )
    }
}

extension String {
    func removingLeadingNumber() -> String {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let index = trimmedText.firstIndex(where: { !$0.isNumber && $0 != "." }) else {
            return self // Return original if no non-numeric character found
        }
        return String(trimmedText[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parserFilter() -> String {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // Combine the check for numbers, periods, and ensure it's not a special character to be removed.
        guard let index = trimmedText.firstIndex(where: { !$0.isNumber && $0 != "." && !$0.isPunctuation }) else {
            return self // Return original if no valid starting point is found.
        }
        return String(trimmedText[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isSingleCharacterABCD: Bool {
        return self.count == 1 && ["A", "B", "C", "D"].contains(self.uppercased())
    }
}

extension Image {
    func iconStyle() -> some View {
        self
            .resizable()
            .frame(width: 25, height: 20)
            .foregroundColor(Color.mint) // Changed to foregroundColor
    }
}



