//
//  Color+Extensions.swift
//  FidraRatingSwift
//
//  Created by Nguyễn Linh on 20/8/26.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Color Hex Initializers & Helpers

public extension Color {
    /// Static helper method to create a `Color` from a hex string (e.g., `Color.hex("FF536D")` or `Color.hex("#FF536D")`).
    static func hex(_ hex: String, opacity: Double = 1.0) -> Color {
        Color(hex: hex, opacity: opacity)
    }
    
    /// Static helper method to create a `Color` from a 24-bit integer (e.g., `Color.hex(0xFF536D)`).
    static func hex(_ hex: UInt, opacity: Double = 1.0) -> Color {
        Color(hex: hex, opacity: opacity)
    }
    
    /// Initializes a `Color` from a hexadecimal string.
    ///
    /// Supported formats:
    /// - RGB (3-digit): e.g. `"F00"`, `"#F00"`
    /// - RGBA (4-digit): e.g. `"F00F"`, `"#F00F"`
    /// - RRGGBB (6-digit): e.g. `"FF536D"`, `"#FF536D"`, `"0xFF536D"`
    /// - RRGGBBAA (8-digit): e.g. `"FF536DFF"`, `"#FF536DFF"`
    ///
    /// - Parameters:
    ///   - hex: The hexadecimal color string (with or without `#` or `0x` prefix).
    ///   - opacity: An optional opacity/alpha value (0.0 to 1.0). Default is 1.0.
    init(hex: String, opacity: Double = 1.0) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanHex.hasPrefix("0X") {
            cleanHex.removeFirst(2)
        } else if cleanHex.hasPrefix("#") {
            cleanHex.removeFirst(1)
        }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: cleanHex).scanHexInt64(&rgbValue) else {
            self = .clear
            return
        }
        
        let r, g, b, a: Double
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            r = Double((rgbValue >> 8) * 17) / 255.0
            g = Double((rgbValue >> 4 & 0xF) * 17) / 255.0
            b = Double((rgbValue & 0xF) * 17) / 255.0
            a = opacity
            
        case 4: // RGBA (16-bit)
            r = Double((rgbValue >> 12) * 17) / 255.0
            g = Double((rgbValue >> 8 & 0xF) * 17) / 255.0
            b = Double((rgbValue >> 4 & 0xF) * 17) / 255.0
            a = (Double(rgbValue & 0xF) * 17 / 255.0) * opacity
            
        case 6: // RRGGBB (24-bit)
            r = Double((rgbValue >> 16) & 0xFF) / 255.0
            g = Double((rgbValue >> 8) & 0xFF) / 255.0
            b = Double(rgbValue & 0xFF) / 255.0
            a = opacity
            
        case 8: // RRGGBBAA (32-bit)
            r = Double((rgbValue >> 24) & 0xFF) / 255.0
            g = Double((rgbValue >> 16) & 0xFF) / 255.0
            b = Double((rgbValue >> 8) & 0xFF) / 255.0
            a = (Double(rgbValue & 0xFF) / 255.0) * opacity
            
        default:
            self = .clear
            return
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    /// Initializes a `Color` from a hexadecimal string.
    ///
    /// - Parameters:
    ///   - hexString: The hexadecimal color string.
    ///   - opacity: An optional opacity/alpha value (0.0 to 1.0). Default is 1.0.
    init(hexString: String, opacity: Double = 1.0) {
        self.init(hex: hexString, opacity: opacity)
    }
    
    /// Initializes a `Color` from a 24-bit integer hex value (e.g., `0xFF536D` or `0x0C5BD5`).
    ///
    /// - Parameters:
    ///   - hex: 24-bit unsigned integer (e.g. `0x0C5BD5`).
    ///   - opacity: Opacity from 0.0 to 1.0 (default is 1.0).
    init(hex: UInt, opacity: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
    
    /// Initializes a `Color` from an integer hex value (e.g., `0x0C5BD5`).
    ///
    /// - Parameters:
    ///   - hex: Integer value (e.g. `0x0C5BD5`).
    ///   - opacity: Opacity from 0.0 to 1.0 (default is 1.0).
    init(hex: Int, opacity: Double = 1.0) {
        self.init(hex: UInt(max(0, hex)), opacity: opacity)
    }
    
    /// Converts the `Color` to a hexadecimal string representation.
    ///
    /// - Parameter includeAlpha: Whether to include the alpha channel in the hex string (default `false`).
    /// - Returns: A hex string formatted like `"#RRGGBB"` or `"#RRGGBBAA"`, or `nil` if conversion fails.
    func toHex(includeAlpha: Bool = false) -> String? {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        return uiColor.toHex(includeAlpha: includeAlpha)
        #else
        return nil
        #endif
    }
}

// MARK: - UIColor Hex Extensions

#if canImport(UIKit)
public extension UIColor {
    /// Static helper method to create a `UIColor` from a hex string (e.g., `UIColor.hex("FF536D")`).
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor? {
        UIColor(hex: hex, alpha: alpha)
    }
    
    /// Static helper method to create a `UIColor` from a 24-bit integer (e.g., `UIColor.hex(0xFF536D)`).
    static func hex(_ hex: UInt, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hex: hex, alpha: alpha)
    }
    
    /// Initializes a `UIColor` from a hexadecimal string.
    ///
    /// Supported formats:
    /// - RGB (3-digit): e.g. `"F00"`, `"#F00"`
    /// - RGBA (4-digit): e.g. `"F00F"`, `"#F00F"`
    /// - RRGGBB (6-digit): e.g. `"FF536D"`, `"#FF536D"`, `"0xFF536D"`
    /// - RRGGBBAA (8-digit): e.g. `"FF536DFF"`, `"#FF536DFF"`
    ///
    /// - Parameters:
    ///   - hex: The hexadecimal color string.
    ///   - alpha: An optional alpha value (0.0 to 1.0). Default is 1.0.
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanHex.hasPrefix("0X") {
            cleanHex.removeFirst(2)
        } else if cleanHex.hasPrefix("#") {
            cleanHex.removeFirst(1)
        }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: cleanHex).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        let r, g, b, a: CGFloat
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            r = CGFloat((rgbValue >> 8) * 17) / 255.0
            g = CGFloat((rgbValue >> 4 & 0xF) * 17) / 255.0
            b = CGFloat((rgbValue & 0xF) * 17) / 255.0
            a = alpha
            
        case 4: // RGBA (16-bit)
            r = CGFloat((rgbValue >> 12) * 17) / 255.0
            g = CGFloat((rgbValue >> 8 & 0xF) * 17) / 255.0
            b = CGFloat((rgbValue >> 4 & 0xF) * 17) / 255.0
            a = (CGFloat(rgbValue & 0xF) * 17 / 255.0) * alpha
            
        case 6: // RRGGBB (24-bit)
            r = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
            g = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
            b = CGFloat(rgbValue & 0xFF) / 255.0
            a = alpha
            
        case 8: // RRGGBBAA (32-bit)
            r = CGFloat((rgbValue >> 24) & 0xFF) / 255.0
            g = CGFloat((rgbValue >> 16) & 0xFF) / 255.0
            b = CGFloat((rgbValue >> 8) & 0xFF) / 255.0
            a = (CGFloat(rgbValue & 0xFF) / 255.0) * alpha
            
        default:
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Initializes a `UIColor` from a hexadecimal string.
    ///
    /// - Parameters:
    ///   - hexString: The hexadecimal color string.
    ///   - alpha: An optional alpha value (0.0 to 1.0). Default is 1.0.
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        self.init(hex: hexString, alpha: alpha)
    }
    
    /// Initializes a `UIColor` from a 24-bit integer hex value (e.g., `0xFF536D`).
    ///
    /// - Parameters:
    ///   - hex: 24-bit unsigned integer (e.g. `0x0C5BD5`).
    ///   - alpha: Alpha from 0.0 to 1.0 (default is 1.0).
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8) & 0xFF) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// Initializes a `UIColor` from an integer hex value (e.g., `0x0C5BD5`).
    ///
    /// - Parameters:
    ///   - hex: Integer value (e.g. `0x0C5BD5`).
    ///   - alpha: Alpha from 0.0 to 1.0 (default is 1.0).
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(hex: UInt(max(0, hex)), alpha: alpha)
    }
    
    /// Converts the `UIColor` to a hexadecimal string representation.
    ///
    /// - Parameter includeAlpha: Whether to include the alpha channel in the hex string (default `false`).
    /// - Returns: A hex string formatted like `"#RRGGBB"` or `"#RRGGBBAA"`, or `nil` if conversion fails.
    func toHex(includeAlpha: Bool = false) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let red = Int(round(r * 255.0))
        let green = Int(round(g * 255.0))
        let blue = Int(round(b * 255.0))
        let alpha = Int(round(a * 255.0))
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        } else {
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}
#endif
