import SwiftUI

// MARK: - Card View
struct CardView<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let backgroundColor: Color
    
    init(
        cornerRadius: CGFloat = AppTheme.cardCornerRadius,
        shadowRadius: CGFloat = 8,
        backgroundColor: Color = Color(.secondarySystemBackground),
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppTheme.smallPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(
                        color: AppTheme.cardShadow,
                        radius: shadowRadius,
                        x: 0,
                        y: 2
                    )
            )
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(AnimationHelper.quick, value: configuration.isPressed)
    }
}

// MARK: - App Title View
struct AppTitleView: View {
    var baseSize: CGFloat = 20
    var body: some View {
        HStack(spacing: 2) {
            Text("💰")
                .font(.system(size: baseSize, weight: .semibold))
                .accessibilityHidden(true)
            GradientText(
                text: "자산랭킹",
                font: AppTheme.getFont(size: baseSize, weight: .bold),
                gradient: AppTheme.pinkGradient
            )
            Text("AssetRank")
                .font(AppTheme.getFont(size: baseSize * 0.5, weight: .light))
                .foregroundColor(.secondary)
                .baselineOffset(-2)
        }
    }
}

// MARK: - Gradient Text
struct GradientText: View {
    let text: String
    let font: Font
    let gradient: LinearGradient
    
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(.clear)
            .overlay(
                gradient
            )
            .mask(
                Text(text).font(font)
            )
    }
}

// MARK: - Signature View
struct SignatureView: View {
    var body: some View {
        HStack {
            Spacer()
            GradientText(
                text: "by GIROK Labs.",
                font: .system(size: 11, weight: .semibold),
                gradient: AppTheme.pinkGradient
            )
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 2)
    }
}

// MARK: - Top Separator
struct TopSeparator: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.separator).opacity(colorScheme == .dark ? 0.25 : 0.18))
            .frame(height: 0.75)
            .cornerRadius(0.5)
            .padding(.horizontal, 12)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.primary))
            
            Text("로딩 중...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .opacity(isAnimating ? 1.0 : 0.8)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Rank Badge
struct RankBadge: View {
    let percentile: Double
    let showDescription: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(rankText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(RankColorHelper.colorForRank(percentile))
            
            if showDescription {
                Text(rankDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var rankText: String {
        if percentile >= 50 {
            return "상위 \(String(format: "%.0f", percentile))%"
        } else {
            return "하위 \(String(format: "%.0f", 100 - percentile))%"
        }
    }
    
    private var rankDescription: String {
        if percentile >= 50 {
            return "상위 \(String(format: "%.2f", percentile))%"
        } else {
            return "하위 \(String(format: "%.2f", 100 - percentile))%"
        }
    }
}

// MARK: - Result Card
struct ResultCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let color: Color
    
    var body: some View {
        CardView(cornerRadius: 16, shadowRadius: 8) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(AppTheme.getFont(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(AppTheme.getFont(size: 24, weight: .bold))
                    .foregroundColor(color)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTheme.getFont(size: 14, weight: .light))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Back Button
struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("다시 입력")
                    .font(AppTheme.getFont(size: 16, weight: .semibold))
            }
            .foregroundColor(.blue)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}


// MARK: - AdMob Banner View (Placeholder)
struct AdMobBannerView: View {
    var body: some View {
        TestAdBannerPlaceholder()
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

// MARK: - 자산 순위 시각화 컴포넌트 (아파트)
struct AssetRankingVisualization: View {
    let percentile: Double
    let netWorth: Int
    
    private let apartmentHeight: CGFloat = 200
    private let floorHeight: CGFloat = 25
    private let totalFloors = 8
    
    var body: some View {
        VStack(spacing: 16) {
            titleSection
            apartmentVisualization
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text("나는 \(floorName)에 살고 있어요")
                .font(AppTheme.getFont(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("내 순자산 \(netWorth.formattedKorean)")
                .font(AppTheme.getFont(size: 14, weight: .light))
                .foregroundColor(.secondary)
        }
    }
    
    private var apartmentVisualization: some View {
        HStack(alignment: .top, spacing: 20) {
            apartmentBuilding
            rankingScale
        }
    }
    
    private var apartmentBuilding: some View {
        VStack(spacing: 0) {
            penthouseFloor
            floorsSection
            groundFloor
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var penthouseFloor: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(width: 100, height: 15)
            .overlay(
                Text("팬트하우스")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
            )
            .overlay(
                userPositionIndicatorForPenthouse
            )
    }
    
    private var userPositionIndicatorForPenthouse: some View {
        Group {
            if percentile >= 99 {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Text("나")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 35)
            }
        }
    }
    
    private var floorsSection: some View {
        ForEach((0..<totalFloors), id: \.self) { floor in
            floorView(for: floor)
        }
    }
    
    private func floorView(for floor: Int) -> some View {
        Rectangle()
            .fill(floorColor(for: floor))
            .frame(width: 100, height: floorHeight)
            .overlay(floorContent(for: floor))
            .overlay(userPositionIndicator(for: floor))
    }
    
    private func floorContent(for floor: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(totalFloors - floor)층")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
            
            Text(floorAssetAmount(for: floor))
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private func userPositionIndicator(for floor: Int) -> some View {
        Group {
            if isUserFloor(floor) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Text("나")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 35)
            }
        }
    }
    
    private var groundFloor: some View {
        Rectangle()
            .fill(Color.brown.opacity(0.8))
            .frame(width: 100, height: 20)
            .overlay(
                Text("상가")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            )
    }
    
    private var rankingScale: some View {
        VStack(alignment: .leading, spacing: 20) {
            penthouseRanking
            floor8Ranking
            floor7Ranking
            floor6Ranking
            floor4Ranking
            groundRanking
        }
        .padding(.leading, 8)
    }
    
    private var penthouseRanking: some View {
        HStack {
            Text("상위 1%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.red)
            Spacer()
            Text("팬트하우스 50억원+")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile >= 99 ? 1.0 : 0.3)
    }
    
    private var floor8Ranking: some View {
        HStack {
            Text("상위 5%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.orange)
            Spacer()
            Text("8층 15억원")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile >= 95 ? 1.0 : 0.3)
    }
    
    private var floor7Ranking: some View {
        HStack {
            Text("상위 10%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.yellow)
            Spacer()
            Text("7층 12억원")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile >= 90 ? 1.0 : 0.3)
    }
    
    private var floor6Ranking: some View {
        HStack {
            Text("상위 25%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.green)
            Spacer()
            Text("6층 8억원")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile >= 75 ? 1.0 : 0.3)
    }
    
    private var floor4Ranking: some View {
        HStack {
            Text("상위 50%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.blue)
            Spacer()
            Text("4층 3억원")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile >= 50 ? 1.0 : 0.3)
    }
    
    private var groundRanking: some View {
        HStack {
            Text("하위 50%")
                .font(AppTheme.getFont(size: 12, weight: .semibold))
                .foregroundColor(.purple)
            Spacer()
            Text("상가 5천만원")
                .font(AppTheme.getFont(size: 12, weight: .medium))
                .foregroundColor(.primary)
        }
        .opacity(percentile < 50 ? 1.0 : 0.3)
    }
    
    private var floorName: String {
        switch percentile {
        case 99...100:
            return "팬트하우스"
        case 95..<99:
            return "8층"
        case 90..<95:
            return "7층"
        case 80..<90:
            return "6층"
        case 70..<80:
            return "5층"
        case 60..<70:
            return "4층"
        case 50..<60:
            return "3층"
        case 25..<50:
            return "2층"
        default:
            return "상가"
        }
    }
    
    private func isUserFloor(_ floor: Int) -> Bool {
        let userFloor = userFloorNumber
        // 팬트하우스는 별도 처리되므로 일반 층에서는 false
        if userFloor == -1 {
            return false
        }
        return floor == userFloor
    }
    
    private var userFloorNumber: Int {
        switch percentile {
        case 0..<0.1:
            return -1  // 팬트하우스 (상위 0.1%) - 별도 처리
        case 0.1..<0.5:
            return -1  // 팬트하우스 (상위 0.5%) - 별도 처리
        case 0.5..<1:
            return -1  // 팬트하우스 (상위 1%) - 별도 처리
        case 1..<5:
            return 0  // 8층 (상위 5%) - floor 0 = 8층
        case 5..<10:
            return 1  // 7층 (상위 10%) - floor 1 = 7층
        case 10..<25:
            return 2  // 6층 (상위 25%) - floor 2 = 6층
        case 25..<50:
            return 3  // 5층 (상위 50%) - floor 3 = 5층
        case 50..<75:
            return 4  // 4층 (상위 75%) - floor 4 = 4층
        case 75..<90:
            return 5  // 3층 (상위 90%) - floor 5 = 3층
        case 90..<95:
            return 6  // 2층 (상위 95%) - floor 6 = 2층
        default:
            return 7  // 1층/상가 (하위 95%) - floor 7 = 1층
        }
    }
    
    private func floorColor(for floor: Int) -> Color {
        let colors: [Color] = [
            Color.red.opacity(0.9),        // 8층 (floor 0)
            Color.red.opacity(0.7),        // 7층 (floor 1)
            Color.orange.opacity(0.7),     // 6층 (floor 2)
            Color.yellow.opacity(0.7),     // 5층 (floor 3)
            Color.green.opacity(0.7),      // 4층 (floor 4)
            Color.blue.opacity(0.7),       // 3층 (floor 5)
            Color.purple.opacity(0.7),     // 2층 (floor 6)
            Color.brown.opacity(0.6)       // 1층 (floor 7)
        ]
        return colors[min(floor, colors.count - 1)]
    }
    
    private func floorAssetAmount(for floor: Int) -> String {
        let amounts = [
            "15억원",     // 8층 (floor 0)
            "12억원",     // 7층 (floor 1)
            "8억원",      // 6층 (floor 2)
            "5억원",      // 5층 (floor 3)
            "3억원",      // 4층 (floor 4)
            "1.5억원",    // 3층 (floor 5)
            "1억원",      // 2층 (floor 6)
            "5천만원"     // 1층 (floor 7)
        ]
        return amounts[min(floor, amounts.count - 1)]
    }
}
