import SwiftUI

public struct DialogRateTemplate1View: View {
    private let imageName: String
    private let scriptModel: ScriptModel
    @State private var rating: Int
    
    public var onRatingSelected: ((Int) -> Void)?
    public var onSubmit: ((Int) -> Void)?
    public var onCancel: (() -> Void)?
    
    public init(
        imageName: String,
        scriptModel: ScriptModel,
        onRatingSelected: ((Int) -> Void)? = nil,
        onSubmit: ((Int) -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.scriptModel = scriptModel
        self.onRatingSelected = onRatingSelected
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self._rating = State(initialValue: scriptModel.dialog.defaultStarRating)
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(12)
                .padding(.top, 16)
            
            VStack(spacing: 4) {
                Text(scriptModel.dialog.contents?["love_it"]?.title ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text(scriptModel.dialog.contents?["love_it"]?.description ?? "")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack(spacing: 12) {
                ForEach(1..<6) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            rating = star
                            handleRatingSelection(star: star)
                        }
                }
            }   
            .padding(.vertical, 12)
            
            Divider()
            
            if rating > 0 {
                HStack(spacing: 0) {
                    Button(action: {
                        // Xử lý hành động "Cancel"
                        onCancel?()
                    }) {
                        Text(scriptModel.dialog.contents?["love_it"]?.cta ?? "")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                    }
                    
                    Divider().frame(height: 44)
                    
                    Button(action: {
                        if rating == 0 {
                            return
                        }
                        onSubmit?(rating)
                    }) {
                        Text(scriptModel.dialog.contents?["love_it"]?.ctaSecondary ?? "")
                            .foregroundColor(.blue)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 8)
                    }
                }
                .frame(height: 44)
            } else {
                Button(action: {
                    onCancel?()
                }) {
                    Text("Not Now")
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                }
            }
        }
        .frame(width: 280)
        .background(.white.opacity(0.7))
        .background(.ultraThinMaterial)
        .cornerRadius(14)
    }
    
    private func handleRatingSelection(star: Int) {
        // Hủy bỏ và gửi đánh giá
        print("Rating selected: \(star)")
        // Thêm logic để gửi đánh giá ở đây
        onRatingSelected?(star)
    }
}
