//
//  LoveIt3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct LoveIt7View: View {
    let scriptModel: ScriptModel
    let onLoveIt: ()->Void
    let onNotGreat: ()->Void
    let onClose: ()->Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 16)
            Text(scriptModel.dialog.contents?["love_it"]?.title ?? "")
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "282828"))
                .lineLimit(2)
                .padding(.bottom, 4)
            
            Image(.imgTemplate7)
                .resizable()
                .scaledToFit()
                .frame(width: 164, height: 164)
            
            Text(scriptModel.dialog.contents?["love_it"]?.description ?? "")
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "282828"))
                .lineLimit(5)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
            
            
            ButtonGlass(isProminent: true, tint: Color(hex: "#FA7C56")) {
                onLoveIt()
            } label: {
                Text(scriptModel.dialog.contents?["love_it"]?.cta ?? "Love it")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 14)
            }.frame(width: 228)
                 
            Spacer().frame(height: 16)
            
            ButtonGlass(isProminent: true, tint: Color(hex: "#FFD6B1")) {
                onNotGreat()
            } label: {
                Text(scriptModel.dialog.contents?["love_it"]?.ctaSecondary ?? "Not great 😐")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 14)
            }.frame(width: 151)
            Spacer().frame(height: 16)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }
}
