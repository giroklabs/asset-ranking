import SwiftUI

struct AppTheme {
    // 메인 컬러
    static let primary = Color.pink
    static let primaryLight = Color.purple
    static let primaryDark = Color.pink.opacity(0.7)
    
    // 세컨더리 컬러
    static let secondary = Color.orange
    static let secondaryLight = Color.orange.opacity(0.8)
    
    // 성공/경고 컬러
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    
    // 자산 순위별 컬러
    static let rankColors: [Color] = [
        .red,       // 상위 1%
        .orange,    // 상위 10%
        .yellow,    // 상위 25%
        .blue,      // 상위 50%
        .green,     // 하위 50%
        .gray       // 하위 25%
    ]
    
    // 그라데이션
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primary, primaryLight]),
        startPoint: .leading,
        endPoint: .trailing
    )

    static let pinkGradient = LinearGradient(
        gradient: Gradient(colors: [Color.pink, Color.purple]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(.systemGroupedBackground),
            Color(.secondarySystemGroupedBackground)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    // 그림자
    static let cardShadow = Color.black.opacity(0.06)
    static let buttonShadow = Color.pink.opacity(0.3)
    
    // 코너 반경
    static let cornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 28
    static let cardCornerRadius: CGFloat = 16
    
    // 패딩
    static let padding: CGFloat = 20
    static let smallPadding: CGFloat = 12
    static let largePadding: CGFloat = 24
    
    // README 권장 헬퍼 함수 (폰트 로딩 타이밍 문제 해결)
    static func maruBuriFont(size: CGFloat) -> Font {
        if let font = UIFont(name: "MaruBuriOTF Regular", size: size) {
            return Font(font)
        }
        return .system(size: size)
    }
    
    // 폰트 설정 - 함수 방식으로 변경 (README 권장)
    static func appFont(size: CGFloat = 16) -> Font {
        return maruBuriFont(size: size)
    }
    
    static func appBoldFont(size: CGFloat = 16) -> Font {
        return maruBuriFont(size: size)
    }
    
    // 폰트 크기 (MaruBuriOTF Regular 타입 체계)
    static func titleFont(size: CGFloat = 22) -> Font {
        return maruBuriFont(size: size)
    }
    
    static func headlineFont(size: CGFloat = 18) -> Font {
        return maruBuriFont(size: size)
    }
    
    static func bodyFont(size: CGFloat = 16) -> Font {
        return maruBuriFont(size: size)
    }
    
    static func captionFont(size: CGFloat = 12) -> Font {
        return maruBuriFont(size: size)
    }
    
    // 추가 폰트 스타일
    static func getFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return maruBuriFont(size: size)
    }
    
    // 디버그 정보 (README 권장)
    static func debugFontInfo() {
        print("🔍 폰트 로딩 상태 확인:")
        print("- MaruBuriOTF Regular 로딩 가능: \(UIFont(name: "MaruBuriOTF Regular", size: 16) != nil)")
        
        let availableFonts = UIFont.familyNames.filter { $0.contains("MaruBuri") }
        print("- 사용 가능한 MaruBuri 폰트: \(availableFonts)")
        
        // 앱 번들에 폰트 파일 존재 여부 확인
        let fontFiles = ["MaruBuri-Regular.otf", "MaruBuri-Regular.ttf"]
        for fontFile in fontFiles {
            if let path = Bundle.main.path(forResource: fontFile.replacingOccurrences(of: ".otf", with: "").replacingOccurrences(of: ".ttf", with: ""), ofType: fontFile.contains(".otf") ? "otf" : "ttf") {
                print("- \(fontFile) 파일 존재: ✅")
            } else {
                print("- \(fontFile) 파일 존재: ❌")
            }
        }
    }
}

struct RankColorHelper {
    static func colorForRank(_ percentile: Double) -> Color {
        switch percentile {
        case 0..<1:
            return AppTheme.rankColors[0] // 상위 1%
        case 1..<10:
            return AppTheme.rankColors[1] // 상위 10%
        case 10..<25:
            return AppTheme.rankColors[2] // 상위 25%
        case 25..<50:
            return AppTheme.rankColors[3] // 상위 50%
        case 50..<75:
            return AppTheme.rankColors[4] // 하위 50%
        default:
            return AppTheme.rankColors[5] // 하위 25%
        }
    }
    
    static func backgroundColorForRank(_ percentile: Double) -> Color {
        return colorForRank(percentile).opacity(0.1)
    }
}

struct AnimationHelper {
    static let quick = Animation.easeInOut(duration: 0.1)
    static let smooth = Animation.easeInOut(duration: 0.2)
    static let bouncy = Animation.spring(response: 0.3, dampingFraction: 0.6)
}
