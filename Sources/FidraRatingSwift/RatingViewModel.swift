//
//  RatingViewModel.swift
//  FidraCore
//
//  Created by hi on 31/3/25.
//

import Foundation
import SwiftUI
import StoreKit

@MainActor
public final class RatingViewModel: ObservableObject {
   @Published public var scriptModel: ScriptModel?
   @Published public var rating: Int?
   @Published public var currentSession: Int = 0 {
       didSet {
           userDefaults.setValue(currentSession, forKey: "current_session")
       }
   }
   public var lastDisplayTime: Date?
   @Published public var displayCountInCurrentSession: [String: Int] = [:] // Thay đổi thành dictionary để lưu số lần hiển thị theo position
   
   var appId: String = ""
   var appleAppId: String = ""
   
   private let ratingRepository = RatingRepository.shared
   private let userDefaults = UserDefaultsManager()
    private let uploadRepository = UploadRepository()
   
   public static let shared = RatingViewModel()
   
   public init() {
       // Khôi phục trạng thái rating từ UserDefaults khi khởi tạo
       self.rating = userDefaults.int(forKey: "app_rating")
       
       // Kiểm tra xem đã có session được lưu trước đó chưa
       if userDefaults.hasValue(forKey: "current_session") {
           // Nếu đã có session trước đó, tăng thêm 1
           self.currentSession = userDefaults.int(forKey: "current_session") + 1
       } else {
           // Nếu chưa có session (lần đầu tiên), bắt đầu từ 0
           self.currentSession = 0
       }
       
       // Lưu lại giá trị session hiện tại
       userDefaults.setValue(currentSession, forKey: "current_session")
   }

   public func configure(appId: String = "", appleAppId: String = "", sendTimeout: TimeInterval = 10.0, receiveTimeout: TimeInterval = 10.0, refreshInterval: Int = 10) {
       self.appId = appId
       self.appleAppId = appleAppId
       if !appId.isEmpty {
           Task {
               await registerAndFetchScript(appId: appId, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, refreshInterval: refreshInterval)
           }
       }
   }
   
   private func registerAndFetchScript(appId: String, sendTimeout: TimeInterval, receiveTimeout: TimeInterval, refreshInterval: Int) async {
       do {
           try await registerDevice(appId: appId)
           await fetchScript(appId: appId, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, refreshInterval: refreshInterval)
       } catch {
           print("❌ Lỗi trong quá trình đăng ký thiết bị và lấy script: \(error.localizedDescription)")
            DispatchQueue.main.async {
               self.scriptModel = ScriptModel.defaultModel
               self.appId = appId
           }
       }
   }
   
   private func fetchScript(appId: String, sendTimeout: TimeInterval, receiveTimeout: TimeInterval, refreshInterval: Int) async {
       do {
           let script = try await ratingRepository.getScripts(appId: appId, sendTimeout: sendTimeout, receiveTimeout: receiveTimeout, refreshInterval: refreshInterval)
           DispatchQueue.main.async {
               self.scriptModel = script
               self.appId = appId
           }
       } catch {
           print("❌ Lỗi khi lấy script: \(error.localizedDescription)")
           DispatchQueue.main.async {
               self.scriptModel = ScriptModel.defaultModel
               self.appId = appId
           }
       }
   }
   
    func submitRating(rating: Int) {
       Task {
           do {
              try await ratingRepository.sendFeedback(appId: appId, star: rating, scriptId: scriptModel?.id ?? "", dialogId: scriptModel?.dialogId)
               DispatchQueue.main.async {
                   self.rating = rating
                   // Lưu rating vào UserDefaults
                   self.userDefaults.setValue(rating, forKey: "app_rating")
               }
           } catch {
               print("❌ Lỗi khi gửi đánh giá: \(error.localizedDescription)")
           }
       }
   }
    public func submitRatingWithFeedback(rating: Int, feedbacks: [AppProblem], feedbackText: String, selectedImages: [UIImage]) {
       Task {
           do {
               // Upload ảnh lên server
               var uploadedImageUrls: [String] = []
               
               for image in selectedImages {
                   if let imageData = image.jpegData(compressionQuality: 0.8) {
                       let fileSize = imageData.count
                       let name = UUID().uuidString
                       
                       if let uploadResult = try await uploadRepository.uploadFile(
                        appId: appId,
                        fileSize: fileSize,
                        name: "\(name).jpg",
                        ext: "jpg",
                        mimeType: "image/jpeg",
                        data: imageData,
                        deviceId: DeviceServices.shared.getDeviceId()
                       ) {
                           uploadedImageUrls.append(uploadResult.linkCdn)
                       }
                   }
               }
            
               try await ratingRepository.sendFeedback(
                appId: appId,
                star: rating,
                scriptId: scriptModel?.id ?? "",
                dialogId: scriptModel?.dialogId,
                attachments: uploadedImageUrls,
                otherProblem: feedbackText,
                problemIds: feedbacks.map { $0.id }
               )
               DispatchQueue.main.async {
                   self.rating = rating
                   // Lưu rating vào UserDefaults
                   self.userDefaults.setValue(rating, forKey: "app_rating")
               }
           } catch {
               print("❌ Lỗi khi gửi đánh giá: \(error.localizedDescription)")
           }
       }
   }
   
    private func registerDevice(appId: String) async throws {
       try await ratingRepository.registerDevice(appId: appId)
   }

   public func openAppStoreReview() {
       if #available(iOS 16.0, *) {
           if let scene = UIApplication.shared.connectedScenes
               .compactMap({ $0 as? UIWindowScene })
               .first(where: { $0.activationState == .foregroundActive }) {
               AppStore.requestReview(in: scene)
               return
           }
       }
       if #available(iOS 10.3, *) {
           SKStoreReviewController.requestReview()
           return
       }
   }
   
   public func shouldShowRating(position: String) -> Bool {
       let rating = userDefaults.int(forKey: "app_rating")
       // Kiểm tra nếu đã rating rồi thì không hiển thị nữa
       if rating > 0 {
           return false
       }
       
       guard let script = scriptModel else { return false }
       
       // Kiểm tra số phiên hiện tại có đủ để hiển thị không
       if currentSession < script.displayFromSession {
           return false
       }
       
       // Kiểm tra khoảng cách giữa các phiên
       if script.displaySessionGap > 0 && currentSession % script.displaySessionGap != 0 {
           return false
       }
       
       if !position.isEmpty {
           // Kiểm tra position có được cấu hình không
           if !script.dialogRatePosition.contains(position) {
               return false
           }
           // Kiểm tra số lần hiển thị trong phiên hiện tại cho position cụ thể
           let displayCount = displayCountInCurrentSession[position] ?? 0
           if displayCount >= script.redisplayCountPerSession {
               return false
           }
       }
       
       // Kiểm tra thời gian giữa các lần hiển thị
       if let lastTime = lastDisplayTime {
           let timeInterval = Date().timeIntervalSince(lastTime)
           if timeInterval < TimeInterval(script.timeGap) {
               return false
           }
       }
       lastDisplayTime = Date()
       if !position.isEmpty {
           let displayCount = displayCountInCurrentSession[position] ?? 0
           displayCountInCurrentSession[position] = displayCount + 1
       }
       
       return true
   }
    
   public func isRating()->Bool{
        return self.rating ?? 0 > 0
    }
}
