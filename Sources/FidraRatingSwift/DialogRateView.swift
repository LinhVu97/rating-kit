import SwiftUI

/// View quản lý các template dialog đánh giá
public struct DialogRateView: View {
    private let imageName: String
    public var buttonColors: [Color] = []
    public var gradientImageColor: [Color] = []
    public var isReview: Bool = false
    private let onResult: (() -> Void)?
    
    @StateObject private var viewModel = RatingViewModel.shared
    
    public init(imageName: String = "", buttonColors: [Color] = [],gradientImageColor: [Color] = [], onResult: (() -> Void)? = nil, isReview: Bool = false) {
        self.imageName = imageName
        self.onResult = onResult
        self.buttonColors = buttonColors
        self.gradientImageColor = gradientImageColor
        self.isReview = isReview
    }
    
    public var body: some View {
        if let templateId = viewModel.scriptModel?.dialog.templateId {
//            switch templateId {
//            case "template_1":
//                DialogRateTemplate1View(
//                    imageName: imageName,
//                    scriptModel: viewModel.scriptModel!,
//                    onRatingSelected: handleRatingSelected,
//                    onSubmit: { rating in
//                        handleSubmit(rating: rating)
//                    },
//                    onCancel: handleCancel
//                )
//            case "template_2":
//                DialogRateTemplate2View(
//                    scriptModel: viewModel.scriptModel!,
//                    onRatingSelected: handleRatingSelected,
//                    onSubmit: handleSubmitWithFeedback,
//                    onCancel: handleCancel
//                )
//            case "template_3":
//                DialogRateTemplate3View (
//                    scriptModel: viewModel.scriptModel!,
//                    rating: viewModel.rating,
//                    colorsAction: buttonColors,
//                    gradientImageColor: gradientImageColor,
//                    onLoveIt: {
//                        handleSubmit(rating: 5)
//                    },
//                    onClose: handleCancel,
//                    onSubmit: { rating, feedbackSelecteds, feedbackText, selectedImages in
//                        handleSubmitWithFeedback(rating: rating, feedbacks: feedbackSelecteds, feedbackText: feedbackText, selectedImages: selectedImages)
//                    }
//                )
//            case "template_4":
//                DialogRateTemplate4View (
//                    scriptModel: viewModel.scriptModel!,
//                    onLoveIt: {
//                        handleSubmit(rating: 5)
//                    },
//                    onClose: handleCancel,
//                    onSubmit: handleSubmitWithFeedback
//                )
//            case "template_6":
//                DialogRateTemplate5View (
//                    scriptModel: viewModel.scriptModel!,
//                    onLoveIt: {
//                        handleSubmit(rating: 5)
//                    },
//                    onClose: handleCancel,
//                    onSubmit: { rating, feedbackSelecteds, feedbackText, selectedImages in
//                        handleSubmitWithFeedback(rating: rating, feedbacks: feedbackSelecteds, feedbackText: feedbackText, selectedImages: selectedImages)
//                    }
//                )
//            case "template_7":
//                DialogRateTemplate6View(
//                    scriptModel: viewModel.scriptModel!,
//                    onRatingSelected: handleRatingSelected,
//                    onSubmit: { rating, feedbackSelecteds, feedbackText, selectedImages in
//                        handleSubmitWithFeedback(rating: rating, feedbacks: feedbackSelecteds, feedbackText: feedbackText, selectedImages: selectedImages)
//                    },
//                    onCancel: handleCancel
//                )
//             case "template_8":
//                DialogRateTemplate7View (
//                    scriptModel: viewModel.scriptModel!,
//                    rating: viewModel.rating,
//                    onLoveIt: {
//                        handleSubmit(rating: 5)
//                    },
//                    onClose: handleCancel,
//                    onSubmit: { rating, feedbackSelecteds, feedbackText, selectedImages in
//                        handleSubmitWithFeedback(rating: rating, feedbacks: feedbackSelecteds, feedbackText: feedbackText, selectedImages: selectedImages)
//                    }
//                )
//            default:
//                EmptyView()
//            }
            DialogRateTemplate7View (
                scriptModel: viewModel.scriptModel!,
                rating: viewModel.rating,
                onLoveIt: {
                    handleSubmit(rating: 5)
                },
                onClose: handleCancel,
                onSubmit: { rating, feedbackSelecteds, feedbackText, selectedImages in
                    handleSubmitWithFeedback(rating: rating, feedbacks: feedbackSelecteds, feedbackText: feedbackText, selectedImages: selectedImages)
                })
        } else {
            EmptyView()
        }
    }
    
    private func handleRatingSelected(rating: Int) {
        viewModel.rating = rating
    }
    
    private func handleSubmit(rating: Int, comment: String = "", feedbackIds: [String] = []) {
        viewModel.submitRating(rating: rating)
        if let openFeedbackUnderXStar = viewModel.scriptModel?.dialog.openFeedbackUnderXStar, rating >= openFeedbackUnderXStar {
            viewModel.openAppStoreReview()
        }
        onResult?()
    }
    
    private func handleSubmitWithFeedback(rating: Int, feedbacks: [AppProblem], feedbackText: String, selectedImages: [UIImage]) {
        viewModel.submitRatingWithFeedback(rating: 1, feedbacks: feedbacks, feedbackText: feedbackText, selectedImages: selectedImages)
        onResult?()
    }
    
    private func handleCancel() {
        onResult?()
    }
}
