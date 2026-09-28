//
//  RateUse3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct RateUs7View: View {
    let scriptModel: ScriptModel
    var onSubmit: ((Int) -> Void)?
    @State private var rating = 0
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(scriptModel.dialog.contents?["\(rating)"]?.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                
                Image("icRatingFace\(rating)",  bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                Text(scriptModel.dialog.contents?["\(rating)"]?.description ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                
                StarView(
                    rating: $rating,
                    filledStarImage: "ratingStar3",
                    emptyStarImage: "RatingStarEmpty3"
                )
                .padding(.top, 12)
                
                HStack {
                    Text("The best rating star")
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Image("icBestRating", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(width: 270)
            .cornerRadius(48)
            
            ButtonGlass(isProminent: true) {
                onSubmit?(rating)
            } label: {
                Text(scriptModel.dialog.contents?["\(rating)"]?.cta ?? "")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity)
        }
    }
}
