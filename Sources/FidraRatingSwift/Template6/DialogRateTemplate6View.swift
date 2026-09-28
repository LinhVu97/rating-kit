import SwiftUI

public struct DialogRateTemplate6View: View {
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
                        Image(.imgTemplate6)
                            .resizable()
                            .scaledToFit()
                            .frame(width: rating != 0 ? 100 : 200,
                                   height: rating != 0 ? 100 : 200)
                            .padding(.top, rating != 0 ? 100 : 200)
                        
                        Text(scriptModel.dialog.contents?["\(rating)"]?.title ?? "")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "141313"))
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height: 4)
                        
                        Text(scriptModel.dialog.contents?["\(rating)"]?.description ?? "")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "141313"))
                            .multilineTextAlignment(.center)
                        
                        StarView(
                            rating: $rating,
                            filledStarImage: "icStar6",
                            emptyStarImage: "icStarEmpty6"
                        )
                        if rating == 0 {
                            HStack {
                                Text("Rate here")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(hex: "3F70FD"))
                                
                                Image(.icRateHere)
                                    .renderingMode(.template)
                                    .foregroundColor(Color(hex: "3F70FD"))
                            }
                        }
                        Spacer().frame(height: 24)
                        
                        if rating > 0 && rating < scriptModel.dialog.openFeedbackUnderXStar {
                            VStack {
                                FeedbackView(
                                    scriptModel: scriptModel,
                                    title: "Send us your feedbacks",
                                    selectedFeedbacks: $feedbackSelecteds,
                                    feedbackText: $feedbackText,
                                    selectedImages: $selectedImages
                                ).padding(24)
                            }
                            .background(Color(hex: "FDF5FF"))
                        }
                    }
                }
                
                if rating > 0 {
                    Button {
                        onSubmit?(rating, feedbackSelecteds, feedbackText, selectedImages)
                    } label: {
                        Text("Submit")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color(hex: "F0C1FB")
                            )
                            .cornerRadius(28)
                            .shadow(color: Color(hex: "D768F9"), radius: 0, x: 0, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color(hex: "EEB6FF"), lineWidth: 2)
                            )
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                            .padding(.horizontal, 24)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "FDF5FF"))
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
