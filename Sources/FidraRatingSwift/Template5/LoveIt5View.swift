//
//  Feedback3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct LoveIt5View: View {
    let scriptModel: ScriptModel
    @Binding var rating: Int
    let onSubmit: ()->Void
    let onClose: ()->Void
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    ZStack (alignment: .topLeading) {
                        VStack(alignment: .center) {
                            Text(scriptModel.dialog.contents?["love_it"]?.title ?? "")
                                .font(.system(size: 18, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "282828"))
                                .lineLimit(2)
                                .padding(.top, 20)
                            
                            Text(scriptModel.dialog.contents?["love_it"]?.description ?? "")
                                .lineLimit(5)
                                .font(.system(size: 14, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "282828"))
                                .padding(.top, 2)
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            Spacer()
                            Button {
                                onClose()
                            } label: {
                                Image(.icCloseCircle)
                            }
                        }
                        .padding(12)
                    }
                    
                    Image(.imgTemplate5)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .padding(.vertical, 16)
                    
                    StarView(
                        rating: $rating
                    )
                    
                    HStack {
                        Text("Rate here")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "2A2929"))
                        Image(.icRateHere)
                            .renderingMode(.template)
                            .foregroundColor(Color(hex: "2A2929"))
                    }
                    
                    Button {
                        onSubmit()
                    } label: {
                        Text("Submit")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(
                                rating == 0
                                    ? LinearGradient(
                                        colors: [Color(hex: "ECECEC"), Color(hex: "ECECEC")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    : LinearGradient(
                                        colors: [Color(hex: "FFB237"), Color(hex: "FF5900")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                            )
                            .cornerRadius(30)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 36)
                }
                .padding(.bottom, 32)
                .background(.white)
                .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
            }
            .ignoresSafeArea()
        }
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        )
    }
}
