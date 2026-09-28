//
//  DialogRateTemplate4View.swift
//  FidraCore
//
//  Created by hi on 12/4/25.
//

import SwiftUI

struct DialogRateTemplate4View: View {
    let scriptModel: ScriptModel
    let onLoveIt: ()->Void
    let onClose: ()->Void
    let onSubmit: ((Int, [AppProblem], String, [UIImage]) -> Void)?
    @State private var isShowFeedback = false
    @State private var rating = 0
    @State private var feedbackText: String = ""
    @State private var feedbackSelecteds: [AppProblem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                    if rating > 0 {
                        Image("icEmoji\(rating)", bundle: .module)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 16)
                    }
                    
                    Text(scriptModel.dialog.contents?["love_it"]?.title ?? "")
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "282828"))
                        .lineLimit(2)
                    HStack {
                        ForEach(1..<6) { e in
                            Image(rating == e ? "icEmoji\(e)Active" : "icEmoji\(e)", bundle: .module)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .onTapGesture {
                                    withAnimation {
                                        rating = e
                                    }
                                }
                        }
                    }
                    .padding(.top, 12)
                    if rating > 0 && rating < scriptModel.dialog.openFeedbackUnderXStar {
                        FeedbackView(scriptModel: scriptModel,
                                     selectedFeedbacks: $feedbackSelecteds,
                                     feedbackText: $feedbackText,
                                     selectedImages: $selectedImages
                        )
                        .padding(.top, 16)
                        .frame(maxHeight: 280)
                    }
                    
                    if rating > 0 {
                        Button {
                            if rating == 0 {
                                return
                            }
                            onSubmit?(rating, feedbackSelecteds, feedbackText, selectedImages)
                        } label: {
                            Text("Submit")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "0C5BD5"), Color(hex: "00358D")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(30)
                        }.padding(.top, 12)
                    }
                }
                .frame(maxWidth: 336)
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .background(.white)
                .cornerRadius(16)
        }
    }
}

