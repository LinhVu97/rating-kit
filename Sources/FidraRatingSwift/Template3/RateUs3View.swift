//
//  RateUse3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct RateUs3View: View {
    let scriptModel: ScriptModel
    let colorsAction : [Color]
    var onSubmit: ((Int) -> Void)?
    @State private var rating = 0
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
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
                        }.padding(.top, 8)
                        
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .frame(width: 270)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button {
                        onSubmit?(rating)
                    } label: {
                        HStack {
                            Image(.star)
                            Text(scriptModel.dialog.contents?["\(rating)"]?.cta ?? "")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 270, height: 48)
                        .background(
                            rating < 1
                                ? LinearGradient(
                                    colors: [Color(hex: "DEDEDE"), Color(hex: "DEDEDE")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                : LinearGradient(
                                    gradient: Gradient(colors: colorsAction),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                        )
                        .cornerRadius(360)
                    }
            }
        }
    }
}

