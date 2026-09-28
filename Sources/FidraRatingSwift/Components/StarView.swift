import SwiftUI

public struct StarView: View {
    @Binding var rating: Int
    var filledStarImage: String
    var emptyStarImage: String
    let isDisable: Bool
    
    public init(
        rating: Binding<Int>,
        filledStarImage: String = "icStarFillTemplate2",
        emptyStarImage: String = "icStarFillEmpty2",
        isDisable: Bool = false
    ) {
        self._rating = rating
        self.filledStarImage = filledStarImage
        self.emptyStarImage = emptyStarImage
        self.isDisable = isDisable
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { index in
                Image(rating >= index ? filledStarImage : emptyStarImage, bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        if !isDisable {
                            rating = index
                        }
                    }
            }
        }
    }
}
