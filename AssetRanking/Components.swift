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
        if percentile < 1 {
            return "상위 1%"
        } else if percentile < 10 {
            return "상위 10%"
        } else if percentile < 25 {
            return "상위 25%"
        } else if percentile < 50 {
            return "상위 50%"
        } else if percentile < 75 {
            return "하위 50%"
        } else {
            return "하위 25%"
        }
    }
    
    private var rankDescription: String {
        return "상위 \(String(format: "%.1f", percentile))%"
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
