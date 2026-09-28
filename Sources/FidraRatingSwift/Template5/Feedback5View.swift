import SwiftUI

public struct Feedback5View: View {
    let scriptModel: ScriptModel
    @Binding var rating: Int
    @Binding var feedbackSelecteds: [AppProblem]
    @Binding var feedbackText: String
    @Binding var selectedImages: [UIImage]
    let onSubmit: ()-> Void
    
    @State private var isTextFieldFocused: Bool = false
    @State private var comment = ""
    
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer().frame(height: 42)
                        Image("icRatingFace\(rating)",  bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                        Text("Rate Us")
                            .font(.system(size: 20, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 12)
                        
                        Text(scriptModel.dialog.contents?["\(rating)"]?.description ?? "")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "2E72D8"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        StarView(
                            rating: $rating,
                            isDisable: true
                        )
                        
                        Spacer().frame(height: 24)
                        
                        if rating < scriptModel.dialog.openFeedbackUnderXStar {
                            VStack {
                                FeedbackView(
                                    scriptModel:scriptModel,
                                    title: "Share with us your ideal and experience",
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
                        onSubmit()
                    } label: {
                        Text("Submit")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FFB237"), Color(hex: "FF5900")],
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
            
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
