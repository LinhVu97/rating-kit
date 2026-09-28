import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showImagePicker: Bool
    let allowFeedbackAndPhoto: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Button(action: {
                                    selectedImages.remove(at: index)
                                }) {
                                    Image(.icCloseButton)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .padding(4)
                                }
                                .offset(x: 8, y: -8)
                            }
                            .padding(.trailing, 8)
                            .padding(.top, 8)
                            .frame(width: 64, height: 64)
                        }
                        
                        if selectedImages.count < 5 {
                            HStack(alignment: .bottom, spacing: 8) {
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Image(.icAddDash)
                                }
                                
                                Text("\(selectedImages.count)/5")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "A1A3AF"))
                            }
                            .padding(.trailing, 8)
                            .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            } else {
                if allowFeedbackAndPhoto {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(.addPhotoAlternateRounded)
                            Text("Add photos").font(.system(size: 12))
                        }
                        .foregroundColor(.blue)
                        .padding(4)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(360)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            }
        }
    }
}
