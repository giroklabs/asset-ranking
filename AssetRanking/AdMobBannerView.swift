import SwiftUI
import GoogleMobileAds

// MARK: - AdMob Banner View
struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String
    
    init(adUnitID: String = "ca-app-pub-4376736198197573/9331611138") {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = adUnitID
        
        // iOS 15+ 에서는 windowScene을 사용
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            bannerView.rootViewController = window.rootViewController
        }
        
        bannerView.delegate = context.coordinator
        bannerView.load(Request())
        // 배너 크기를 강제로 제한
        bannerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Updates handled automatically
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, BannerViewDelegate {
        var parent: AdMobBannerView
        
        init(_ parent: AdMobBannerView) {
            self.parent = parent
        }
        
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ AdMob 배너 광고가 성공적으로 로드되었습니다.")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ AdMob 배너 광고 로드 실패: \(error.localizedDescription)")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print("📱 광고 화면이 표시됩니다.")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print("📱 광고 화면이 닫혔습니다.")
        }
    }
}

// MARK: - Test Ad Placeholder (Fallback)
struct TestAdBannerPlaceholder: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "rectangle.badge.plus")
                .foregroundColor(.secondary)
            Text("Ad · Test Banner")
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.tertiarySystemFill))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor.separator).opacity(colorScheme == .dark ? 0.6 : 0.3), lineWidth: 0.5)
                )
        )
    }
}
