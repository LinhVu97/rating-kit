import SwiftUI

struct FeedbackButton: View {
    let text: String
    let isSelected: Bool
    let foregroundColor: Color = Color(hex: "2B2929")
    let backgroundColor: Color = Color.white
    let strokeColor: Color = Color.black.opacity(0.1)
    let action: () -> Void
   
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "2E72D8") : Color(hex: "2B2929"))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: "6DA8FF").opacity(0.3) : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? Color(hex: "2E72D8") : Color.black.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
} 
