//
//  Feedback3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct Feedback7View: View {
    let scriptModel: ScriptModel
    @Binding var feedbackSelecteds: [AppProblem]
    @Binding var feedbackText: String
    @Binding var selectedImages: [UIImage]
    let onSubmit: ()-> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(scriptModel.dialog.contents?["0"]?.title ?? "Let us know what are facing with?")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "010101"))
                    .lineLimit(2)
                Spacer()
            }
            
            FeedbackView(
                scriptModel: scriptModel,
                selectedFeedbacks: $feedbackSelecteds,
                feedbackText: $feedbackText,
                selectedImages: $selectedImages
            ).padding(.top, 16)
            
            
            ButtonGlass(isProminent: true, tint: Color(hex: "#FA7C56")) {
                onSubmit()
            } label: {
                Text(scriptModel.dialog.contents?["0"]?.cta ?? "Submit")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 14)
            }.frame(width: 228)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .cornerRadius(16)
    }
}
