//
//  LoveIt3View.swift
//  FidraCore
//
//  Created by hi on 3/4/25.
//

import SwiftUI

struct LoveIt3View: View {
    let scriptModel: ScriptModel
    let colorsAction : [Color]
    let grandientImageColors : [Color]
    let onLoveIt: ()->Void
    let onNotGreat: ()->Void
    let onClose: ()->Void
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                    VStack {
                        Text(scriptModel.dialog.contents?["love_it"]?.title ?? "")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "282828"))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 4)
                        
                        
                        Text(scriptModel.dialog.contents?["love_it"]?.description ?? "")
                            .lineLimit(5)
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "282828"))
                        
                    }.padding(16)
                    
                    ZStack {
                        Image(.imgRate3Blue)
                            .resizable()
                          
                            .scaledToFit()
                            .frame(width: 194, height: 194, alignment: .center)
                            .padding(.vertical, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: grandientImageColors,
                                               startPoint: .top,
                                               endPoint: .bottom))
                 
                    
                    Button {
                        onLoveIt()
                    } label: {
                        Text(scriptModel.dialog.contents?["love_it"]?.cta ?? "")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.white)
                            .frame(width: 298, height: 48)
                            .background(
                                LinearGradient(
                                   gradient: Gradient(colors: colorsAction),
                                   startPoint: .leading,
                                   endPoint: .trailing
                               )
                            )
                            .cornerRadius(360)
                    }
                    
                    Button {
                        onNotGreat()
                    } label: {
                        Text(scriptModel.dialog.contents?["love_it"]?.ctaSecondary ?? "")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "2B2929"))
                            .frame(width: 296, height: 48)
                            .background(Color(hex: "F3F3F3"))
                            .cornerRadius(360)
                        
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }
                .frame(width: 336)
                .background(Color.white)
                .cornerRadius(16)
        }
    }
}

