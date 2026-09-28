# FidraRatingSwift

Thư viện SwiftUI cung cấp hệ thống dialog đánh giá ứng dụng (App Rating) với nhiều template có sẵn, hỗ trợ thu thập feedback từ người dùng và tích hợp App Store Review.

## Tính năng

- 🎨 **7 template dialog** có sẵn — dễ dàng chuyển đổi qua cấu hình server
- ⭐ **Star rating** — component đánh giá sao có thể tuỳ chỉnh icon
- 💬 **Thu thập feedback** — cho phép người dùng chọn vấn đề, nhập text và đính kèm ảnh
- 🏪 **App Store Review** — tự động mở native review dialog khi rating đạt ngưỡng
- 🔄 **Hiển thị thông minh** — kiểm soát thời điểm hiển thị dựa trên session, vị trí, khoảng cách thời gian
- 🌐 **Đa ngôn ngữ** — hỗ trợ localization

## Yêu cầu

| Yêu cầu | Phiên bản tối thiểu |
| ------- | ------------------- |
| iOS     | 15.0+               |
| Swift   | 5.9+                |
| Xcode   | 15.0+               |

## Cài đặt

### Swift Package Manager

Thêm dependency vào file `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://gitlab.volio.vn/fidra/libs/fidra-rating-swift.git",
        .upToNextMajor(from: "1.0.0")
    )
]
```

Hoặc trong Xcode: **File → Add Package Dependencies...** → nhập URL:

```
https://gitlab.volio.vn/fidra/libs/fidra-rating-swift.git
```

## Tích hợp

### 1. Cấu hình RatingViewModel

Gọi `configure` trong quá trình khởi tạo ứng dụng (ví dụ: Splash):

```swift
import FidraRatingSwift

// Trong SplashViewModel hoặc AppDelegate
RatingViewModel.shared.configure(
    appId: <App ID trên CMS>,
    appleAppId: <Apple App ID>,
    sendTimeout: 10.0,
    receiveTimeout: 10.0,
    refreshInterval: 10
)
```

**Tham số `configure`:**

| Tham số           | Kiểu           | Mặc định | Mô tả                                  |
| ----------------- | -------------- | -------- | -------------------------------------- |
| `appId`           | `String`       | `""`     | ID ứng dụng trên hệ thống Fidra        |
| `appleAppId`      | `String`       | `""`     | Apple App ID (cho App Store review)    |
| `sendTimeout`     | `TimeInterval` | `10.0`   | Timeout gửi request (giây)             |
| `receiveTimeout`  | `TimeInterval` | `10.0`   | Timeout nhận response (giây)           |
| `refreshInterval` | `Int`          | `10`     | Khoảng thời gian refresh script (giây) |

Khi `configure` được gọi, thư viện sẽ tự động:

1. Đăng ký thiết bị với server (`registerDevice`)
2. Lấy cấu hình script từ server (template, vị trí hiển thị, điều kiện hiển thị...)

### 2. Đăng ký Dialog Rate

Sử dụng `DialogRegistry` để đăng ký dialog đánh giá:

```swift
import FidraRatingSwift
import FidraRouting

// Trong DialogRouter hoặc nơi đăng ký dialog
DialogRegistry.shared.register(viewId: .dialogRate) { params in
    DialogRateView(
        imageName: "logo",                                          // Tên ảnh logo trong Assets
        buttonColors: [Color(hex: "#F85BB7"), Color(hex: "#9C165B")], // Gradient cho nút action
        gradientImageColor: [Color.white, Color(hex: "#FAD3E7")],    // Gradient cho background ảnh
        onResult: {
            // Close dialog
        }
    )
}
```

**Tham số `DialogRateView`:**

| Tham số              | Kiểu         | Mô tả                                          |
| -------------------- | ------------ | ---------------------------------------------- |
| `imageName`          | `String`     | Tên ảnh logo hiển thị trong dialog             |
| `buttonColors`       | `[Color]`    | Mảng màu gradient cho nút action               |
| `gradientImageColor` | `[Color]`    | Mảng màu gradient cho background ảnh           |
| `isReview`           | `Bool`       | Đánh dấu có đang trong trạng thái review không |
| `onResult`           | `() -> Void` | Callback khi user hoàn thành hoặc đóng dialog  |

### 3. Hiển thị dialog đánh giá

Sử dụng `shouldShowRating(position:)` để kiểm tra điều kiện hiển thị trước khi show dialog:

```swift
import FidraRatingSwift

// Cách 1: Kiểm tra position trước khi hiển thị
func showDialogRate(_ position: String = "") {
    if !position.isEmpty && !RatingViewModel.shared.shouldShowRating(position: position) {
        return
    }
    RouterManager.showDialog(viewId: .dialogRate)
}

// Gọi tại các vị trí trong app
showDialogRate("home")
showDialogRate("after_save")
showDialogRate("after_export")
```

**Logic kiểm tra `shouldShowRating`:**

Hàm sẽ trả về `false` nếu bất kỳ điều kiện nào sau đây đúng:

| Điều kiện                | Mô tả                                                       |
| ------------------------ | ----------------------------------------------------------- |
| Đã rating                | User đã đánh giá trước đó (`rating > 0`)                    |
| Chưa đủ session          | `currentSession < displayFromSession`                       |
| Chưa đúng chu kỳ session | `currentSession % displaySessionGap != 0`                   |
| Position không hợp lệ    | `position` không nằm trong `dialogRatePosition` của script  |
| Vượt giới hạn hiển thị   | Số lần hiển thị tại `position` ≥ `redisplayCountPerSession` |
| Chưa đủ thời gian chờ    | Khoảng cách với lần hiển thị trước < `timeGap`              |

### 4. Kiểm tra trạng thái đánh giá

```swift
// Kiểm tra user đã đánh giá chưa
if RatingViewModel.shared.isRating() {
    // Đã đánh giá — ẩn nút hoặc không show dialog nữa
}
```

### 5. Sử dụng với DialogRateWrapper (có callback onDismiss)

Khi cần thực hiện hành động sau khi dialog đóng:

```swift
struct DialogRateWrapper: View {
    var onDismiss: (() -> Void)?

    var body: some View {
        DialogRateView(
            imageName: "logo",
            buttonColors: [Color(hex: "#F85BB7"), Color(hex: "#9C165B")],
            gradientImageColor: [Color.white, Color(hex: "#FAD3E7")],
            onResult: {
                RouterManager.dismissDialog()
            }
        )
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onDismiss?()
            }
        }
    }
}
```

## Flow hoạt động

```
App Launch
    │
    ▼
RatingViewModel.shared.configure(...)
    │
    ├─► registerDevice(appId)     ── Đăng ký thiết bị
    └─► fetchScript(appId, ...)   ── Lấy cấu hình (template, position, điều kiện)
         │
         ▼
    scriptModel được lưu
         │
         ▼
Tại vị trí cần show ──► shouldShowRating(position: "xxx")
         │
    ┌────┴────┐
    │         │
  false     true
    │         │
  Bỏ qua   RouterManager.showDialog(viewId: .dialogRate)
              │
              ▼
         DialogRateView hiển thị template từ scriptModel
              │
         ┌────┴────┐
         │         │
      Rating ≥ X  Rating < X
         │         │
  openAppStore   FeedbackView
  Review()       (chọn vấn đề, nhập text, đính kèm ảnh)
         │         │
         └────┬────┘
              │
         submitRating / submitRatingWithFeedback
              │
              ▼
         onResult() ──► Dismiss dialog
```

## Template

Thư viện hỗ trợ **7 template** dialog đánh giá, được cấu hình từ server thông qua `templateId`:

| Template ID  | Mô tả                                         |
| ------------ | --------------------------------------------- |
| `template_1` | Dialog cơ bản với star rating                 |
| `template_2` | Dialog với star rating + feedback             |
| `template_3` | Flow nhiều bước: Love It → Rate Us → Feedback |
| `template_4` | Flow Love It → Feedback                       |
| `template_6` | Flow Love It → Feedback (biến thể)            |
| `template_7` | Dialog star rating + feedback chi tiết        |
| `template_8` | Flow nhiều bước: Love It → Rate Us → Feedback |

Template được server quyết định thông qua `scriptModel.dialog.templateId`. Nếu rating ≥ `openFeedbackUnderXStar`, thư viện tự động gọi `openAppStoreReview()` để mở native App Store review dialog.

## Cấu trúc thư viện

```
Sources/FidraRatingSwift/
├── DialogRateView.swift          # View chính — điều phối các template
├── RatingViewModel.swift         # ViewModel — quản lý logic hiển thị & gửi đánh giá
├── Components/
│   ├── StarView.swift            # Component đánh giá sao
│   ├── FeedbackView.swift        # Giao diện thu thập feedback
│   ├── FeedbackFlowLayout.swift  # Layout danh sách vấn đề
│   ├── FeedbackButton.swift      # Nút chọn vấn đề
│   ├── TextInputView.swift       # Ô nhập text feedback
│   ├── ImagePicker.swift         # Chọn ảnh từ thư viện
│   ├── ImagePickerView.swift     # Hiển thị ảnh đã chọn
│   └── DashedBorder.swift        # Border nét đứt
├── Template1/ ... Template7/     # 7 template dialog khác nhau
└── Resources/
    ├── Assets.xcassets/           # Hình ảnh, icon
    └── Localization/              # File ngôn ngữ
```

## Dependencies

- [FidraExtensions](https://gitlab.volio.vn/fidra/libs/fidra-extension-swift) `>= 1.0.4` — Swift extensions
