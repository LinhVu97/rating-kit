import SwiftUI

public struct FeedbackView: View {
    public let scriptModel: ScriptModel
    var title: String? = nil
    @State private var feedbackSelected: AppProblem?
    @Binding public var selectedFeedbacks: [AppProblem]
    @Binding public var feedbackText: String
    @Binding public var selectedImages: [UIImage]
    let foregroundColor: Color =  Color(hex: "2E72D8")
    let backgroundColor: Color =  Color(hex: "6DA8FF")
    let strokeColor: Color =  Color(hex: "2E72D8")
    @State private var isSubmitting: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isTextFieldFocused: Bool = false
    
    public init(scriptModel: ScriptModel, title: String? = nil, feedbackSelected: AppProblem? = nil, selectedFeedbacks: Binding<[AppProblem]>, feedbackText: Binding<String>, selectedImages: Binding<[UIImage]>, isSubmitting: Bool = false, showImagePicker: Bool = false, keyboardHeight: CGFloat = 0, isTextFieldFocused: Bool = false) {
        self.scriptModel = scriptModel
        self.title = title
        self.feedbackSelected = feedbackSelected
        self._selectedFeedbacks = selectedFeedbacks
        self._feedbackText = feedbackText
        self._selectedImages = selectedImages
        self.isSubmitting = isSubmitting
        self.showImagePicker = showImagePicker
        self.keyboardHeight = keyboardHeight
        self.isTextFieldFocused = isTextFieldFocused
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    if title != nil {
                        Text(title ?? "")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "2B2929"))
                            .multilineTextAlignment(.center)
                    }
                    
                    FeedbackFlowLayout(
                        feedbacks: scriptModel.dialog.appProblems,
                        selectedFeedback: $feedbackSelected,
                        selectedFeedbacks: $selectedFeedbacks
                    ) { feedback in
                        feedbackSelected = feedback
                    }
                    
                    Spacer().frame(height: 16)
                    
                    if selectedFeedbacks.contains(where: {$0.sendText == true}) {
                        ZStack(alignment: .topLeading) {
                            let _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isTextFieldFocused = true
                            }
                            TextInputView(text: $feedbackText, isTextFieldFocused: .init(get: { isTextFieldFocused }, set: { isTextFieldFocused = $0 })) { focused in
                                if focused {
                                    DispatchQueue.main.async {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            proxy.scrollTo("textField", anchor: .bottom)
                                        }
                                    }
                                }
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("\(feedbackText.count)/500").font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(hex: "A1A3AF"))
                                    
                                }.padding(.horizontal, 12)
                                ImagePickerView(
                                    selectedImages: $selectedImages,
                                    showImagePicker: $showImagePicker,
                                    allowFeedbackAndPhoto: scriptModel.dialog.allowFeedbackAndPhoto
                                )
                            }
                        }
                        .background(Color(hex: "E9EAF1"))
                        .cornerRadius(8)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: keyboardHeight > 0 ? keyboardHeight - 20 : 0)
            }
            .onAppear {
                setupKeyboardObservers(proxy: proxy)
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages, selectionLimit: 5 - selectedImages.count)
        }
    }
    
    private func setupKeyboardObservers(proxy: ScrollViewProxy) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
            
            DispatchQueue.main.async {
                self.keyboardHeight = keyboardFrame.height
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [proxy] in
//                withAnimation(.easeInOut(duration: 0.3)) {
//                    proxy.scrollTo("textField", anchor: .bottom)
//                }
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [proxy] in
//                withAnimation(.easeInOut(duration: 0.3)) {
//                    proxy.scrollTo("textField", anchor: .bottom)
//                }
//            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                self.keyboardHeight = 0
            }
        }
    }
}
