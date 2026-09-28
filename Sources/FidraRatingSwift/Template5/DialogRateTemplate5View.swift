//
//  DialogRateTemplate4View.swift
//  FidraCore
//
//  Created by hi on 12/4/25.
//

import SwiftUI

struct DialogRateTemplate5View: View {
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
        if isShowFeedback {
            Feedback5View(
                scriptModel: scriptModel,
                rating: $rating, feedbackSelecteds: $feedbackSelecteds,
                feedbackText: $feedbackText,
                selectedImages: $selectedImages)
            {
                onSubmit?(rating, feedbackSelecteds, feedbackText, selectedImages)

            }
        } else {
            LoveIt5View(scriptModel: scriptModel, rating: $rating, onSubmit: {
                if rating >= scriptModel.dialog.openFeedbackUnderXStar {
                    onLoveIt()
                    return
                }
                if rating == 0 {
                    return
                }
                self.isShowFeedback = true
            }, onClose: onClose)
        }
    }
}

