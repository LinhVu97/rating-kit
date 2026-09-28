//
//  Feedback3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct Feedback3View: View {
    let scriptModel: ScriptModel
    let colorsAction : [Color]
    @State private var feedbackSelected: AppProblem?
    @Binding var feedbackSelecteds: [AppProblem]
    @Binding var feedbackText: String
    @Binding var selectedImages: [UIImage]
    let onSubmit: ()-> Void
    
    @State private var isTextFieldFocused: Bool = false
    @State private var isActiveButtonFeeadback: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                    Text(scriptModel.dialog.contents?["0"]?.title ?? "Let us know what are facing with?")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "010101"))
                        .lineLimit(2)
                    
                    FeedbackView(
                        scriptModel: scriptModel,
                        selectedFeedbacks: $feedbackSelecteds,
                        feedbackText: $feedbackText,
                        selectedImages: $selectedImages
                    ).padding(.top, 16)
                    
                    Button {
                        onSubmit()
                    } label: {
                        Text(scriptModel.dialog.contents?["0"]?.cta ?? "Submit")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.white)
                            .lineLimit(2)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .frame(width: 300, height: 48)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: colorsAction),
                                   startPoint: .leading,
                                   endPoint: .trailing
                               )
                            )
//                            .background(LinearGradient.gF360B1_A7115F)
                            .cornerRadius(360)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .frame(width: 336, height: UIScreen.main.bounds.height * 0.6)
                .background(.white)
                .cornerRadius(16)
        }
    }
}
