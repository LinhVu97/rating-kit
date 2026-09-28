//
//  ButtonGlass.swift
//  FidraRatingSwift
//
//  Created by Nguyễn Linh on 20/8/26.
//

import SwiftUI

public struct ButtonGlass<Label: View>: View {
    public var isProminent: Bool
    public var tint: Color?
    public var backgroundColor: Color
    public var cornerRadius: CGFloat
    public let action: () -> Void
    private let label: Label
    
    // MARK: - Initializer with Custom Label ViewBuilder
    
    public init(
        isProminent: Bool = false,
        tint: Color? = nil,
        backgroundColor: Color = Color(hex: "0C5BD5"),
        cornerRadius: CGFloat = 24,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.isProminent = isProminent
        self.tint = tint
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
        self.label = label()
    }
    
    // MARK: - Body (iOS >= 26: .glass / .glassProminent + .tint, iOS < 26: Standard background)
    
    @ViewBuilder
    public var body: some View {
        if #available(iOS 26.0, *) {
            if isProminent {
                Button(action: action) {
                    label
                        .frame(maxWidth: .infinity)
                }
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .tint(tint)
            } else {
                Button(action: action) {
                    label
                        .frame(maxWidth: .infinity)
                }
                .buttonSizing(.flexible)
                .buttonStyle(.glass)
                .tint(tint)
            }
        } else {
            Button(action: action) {
                label
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(tint ?? backgroundColor)
                    )
            }
        }
    }
}

// MARK: - Convenience Initializer for Text Title

extension ButtonGlass where Label == Text {
    public init(
        title: String,
        isProminent: Bool = false,
        tint: Color? = nil,
        backgroundColor: Color = Color(hex: "0C5BD5"),
        foregroundColor: Color = .white,
        font: Font = .system(size: 16, weight: .semibold),
        cornerRadius: CGFloat = 24,
        action: @escaping () -> Void
    ) {
        self.init(
            isProminent: isProminent,
            tint: tint,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            action: action
        ) {
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ButtonGlass_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 1. Standard Glass
                ButtonGlass {
                    print("Standard glass tapped")
                } label: {
                    Text("Tap Me (.glass)")
                        .font(.headline)
                }
                
                // 2. Tinted Glass
                ButtonGlass(tint: .red) {
                    print("Tinted glass tapped")
                } label: {
                    Text("Tinted Tap Me (.tint)")
                        .font(.headline)
                }
                
                // 3. Glass Prominent with Tint
                ButtonGlass(isProminent: true, tint: .red) {
                    print("Prominent tapped")
                } label: {
                    Text("Prominent Tap Me")
                        .font(.headline)
                }
                
                // 4. Convenience Title Initializer
                ButtonGlass(title: "Submit", tint: .blue) {
                    print("Submit tapped")
                }
            }
            .padding()
        }
    }
}
#endif
