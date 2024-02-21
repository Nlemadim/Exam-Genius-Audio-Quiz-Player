//
//  UIExtensions.swift
//  Exam Genius
//
//  Created by Tony Nlemadim on 2/21/24.
//

import Foundation
import SwiftUI

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
    
//    static var topInsets: Double {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            return keyWindow.safeAreaInsets.top
//        }
//        return 0.0
//    }
}

extension UIImage {
    func dominantColor() -> UIColor? {
        // This is a placeholder for the actual implementation
        // You might use a more sophisticated algorithm to find the dominant color
        guard let inputImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: inputImage.extent)])
        guard let outputImage = filter?.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1)
        
        /// Use the dominant color for backgrounds
        //let image = UIImage(named: "yourImageName")!
        //.background(Color(image.dominantColor() ?? .gray)) // Fallback to gray if nil
    }
}
