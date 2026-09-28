import SwiftUI
import Combine

struct TextInputView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    @State private var isTextFieldFocused: Bool = false
    let onFocusChange: (Bool) -> Void
    
    init(text: Binding<String>, isTextFieldFocused: Binding<Bool>, onFocusChange: @escaping (Bool) -> Void) {
        _text = text
        _isFocused = isTextFieldFocused
        self.onFocusChange = onFocusChange
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                TextEditor(text: $text)
                .font(.system(size: 14, weight: .medium))
                .zIndex(100)
                .id("textField")
                .onReceive(Just(text)) { newText in
                    if newText.count > 500 {
                        text = String(newText.prefix(500))
                    }
                }
                .onTapGesture {
                    if !isTextFieldFocused {
                        isTextFieldFocused = true
                        isFocused = true
                        onFocusChange(true)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
                Spacer()
            }
            
            if text.isEmpty {
              VStack {
                Text("Type your text here")
                   .font(.system(size: 14, weight: .medium))
                   .foregroundColor(Color(hex: "010101").opacity(0.5))
                 Spacer()
              }
            }
        }
        .background(Color(hex: "E9EAF1"))
        .padding(16)
        .frame(height: 209)
        .onTapGesture {
            if !isTextFieldFocused {
                isTextFieldFocused = true
                isFocused = true
                onFocusChange(true)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isTextFieldFocused = false
        isFocused = false
        onFocusChange(false)
    }
}
