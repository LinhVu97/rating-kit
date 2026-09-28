import SwiftUI

public struct DialogRateTemplate2View: View {
    @State private var rating: Int
    @State private var feedbackText: String = ""
    @State private var feedbackSelecteds: [AppProblem] = []
    @State var selectedImages: [UIImage] = []
    private let scriptModel: ScriptModel
    private let onRatingSelected: ((Int) -> Void)?
    private let onSubmit: ((Int, [AppProblem], String, [UIImage]) -> Void)?
    private let onCancel: (() -> Void)?
    
    public init(
        scriptModel: ScriptModel,
        onRatingSelected: ((Int) -> Void)? = nil,
        onSubmit: ((Int, [AppProblem], String, [UIImage]) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.scriptModel = scriptModel
        self.onRatingSelected = onRatingSelected
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self._rating = State(initialValue: scriptModel.dialog.defaultStarRating)
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Image(.icHeaderTemplate2)
                            .resizable()
                            .scaledToFit()
                            .frame(width: rating != 0 ? 100 : 200,
                                   height: rating != 0 ? 100 : 200)
                            .padding(.top, rating != 0 ? 100 : 200)
                        
                        Text(scriptModel.dialog.contents?["\(rating)"]?.title ?? "")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "2E72D8"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                        
                        Text(scriptModel.dialog.contents?["\(rating)"]?.description ?? "")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "2B2929"))
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .padding(.horizontal, 10)
                        
                        StarView(
                            rating: $rating
                        )
                        if rating == 0 {
                            HStack {
                                Text("Rate here")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "F54141"))
                                Image(.icRateHere)
                                    .renderingMode(.template)
                                    .foregroundColor(Color(hex: "F54141"))
                            }
                        }
                        
                        
                        Spacer().frame(height: 24)
                        
                        if rating > 0 && rating < scriptModel.dialog.openFeedbackUnderXStar {
                            VStack {
                                FeedbackView(
                                    scriptModel:scriptModel,
                                    title: "Send us your feedbacks",
                                    selectedFeedbacks: $feedbackSelecteds,
                                    feedbackText: $feedbackText,
                                    selectedImages: $selectedImages
                                ).padding(24)
                            }
                            .background(Color(hex: "F9F9FC"))
                        }
                    }
                }
                
                if rating > 0 {
                    Button {
                        if rating == 0 {
                            return
                        }
                        onSubmit?(rating, feedbackSelecteds, feedbackText, selectedImages)
                    } label: {
                        Text(scriptModel.dialog.contents?["\(rating)"]?.cta ?? "Submit")
                            .font(.system(size: 16, weight: .semibold))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "0C5BD5"), Color(hex: "00358D")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(30)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
                onCancel?()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .padding(16)
            }
            .padding(.top, 32)
            
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
