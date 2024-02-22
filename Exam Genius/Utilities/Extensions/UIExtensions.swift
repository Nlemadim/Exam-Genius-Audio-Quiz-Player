//
//  UIExtensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import Foundation
import SwiftUI
import UIKit

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
}

extension View {
    func dynamicExactGradientBackground(startColor: Color, endColor: Color) -> some View {
        let startPoint = UnitPoint(x: 0.49999998837676157, y: 2.9479518284275417e-15)
        let endPoint = UnitPoint(x: 0.4999999443689973, y: 0.9363635917143408)
        
        return self.background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                                              startPoint: startPoint,
                                              endPoint: endPoint))
        
    }
}



