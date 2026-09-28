//
//  DialogRateTemplate3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//


import SwiftUI

struct DialogRateTemplate3View: View {
    let scriptModel: ScriptModel
    let rating: Int?
    let colorsAction : [Color]
    let gradientImageColor : [Color]
    let onLoveIt: ()->Void
    let onClose: ()->Void
    let onSubmit: ((Int, [AppProblem], String, [UIImage]) -> Void)?
    @State private var isShowRateUs = false
    @State private var isShowFeedback = false
    @State private var feedbackText: String = ""
    @State private var feedbackSelecteds: [AppProblem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        if isShowRateUs || (rating ?? 0) > 0 {
            Feedback3View(scriptModel: scriptModel,
                            colorsAction: colorsAction,
                            feedbackSelecteds: $feedbackSelecteds,
                            feedbackText: $feedbackText,
                            selectedImages: $selectedImages
            ) {
                onSubmit?(1, feedbackSelecteds, feedbackText, selectedImages)
            }
        } else {
            LoveIt3View(scriptModel: scriptModel,
                        colorsAction: colorsAction,
                        grandientImageColors: gradientImageColor,
                        onLoveIt: onLoveIt, onNotGreat: {
                self.isShowRateUs = true
            }, onClose: onClose)
        }
    }
}

