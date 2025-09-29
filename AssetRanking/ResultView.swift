import SwiftUI

struct ResultView: View {
    let result: AssetRankingResult
    let onBack: () -> Void
    
    @State private var showingDetails = false
    @State private var animationOffset: CGFloat = 50
    @State private var animationOpacity: Double = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경 그라데이션
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 헤더
                    VStack(spacing: 16) {
                        HStack {
                            BackButton(action: onBack)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // 결과 타이틀
                        VStack(spacing: 8) {
                            Text("자산 순위 결과")
                                .font(AppTheme.getFont(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("당신의 순자산 순위는")
                                .font(AppTheme.getFont(size: 16, weight: .light))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 메인 결과 카드
                    CardView(cornerRadius: 20, shadowRadius: 12) {
                        VStack(spacing: 24) {
                            // 순위 배지
                            VStack(spacing: 16) {
                                RankBadge(
                                    percentile: result.percentile,
                                    showDescription: true
                                )
                                
                                Text(result.description)
                                    .font(AppTheme.getFont(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // 자산 금액
                            VStack(spacing: 8) {
                                Text("순자산액")
                                    .font(AppTheme.getFont(size: 16, weight: .light))
                                    .foregroundColor(.secondary)
                                
                                Text("₩\(result.netWorth.formattedWithCommas)")
                                    .font(AppTheme.getFont(size: 32, weight: .bold))
                                    .foregroundColor(RankColorHelper.colorForRank(result.percentile))
                            }
                            
                            // 순위 정보
                            VStack(spacing: 12) {
                                HStack {
                                    Text("전체 순위")
                                        .font(AppTheme.getFont(size: 14, weight: .light))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(result.rank.formattedWithCommas)위")
                                        .font(AppTheme.getFont(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                HStack {
                                    Text("상위 비율")
                                        .font(AppTheme.getFont(size: 14, weight: .light))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(result.percentile.formattedPercent)
                                        .font(AppTheme.getFont(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .offset(y: animationOffset)
                    .opacity(animationOpacity)
                    
                    // 상세 통계 카드들
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ResultCard(
                            title: "평균 순자산",
                            value: "₩\(result.averageNetWorth.formattedWithCommas)",
                            subtitle: "전국 평균",
                            color: .blue
                        )
                        
                        ResultCard(
                            title: "중간값 순자산",
                            value: "₩\(result.medianNetWorth.formattedWithCommas)",
                            subtitle: "전국 중간값",
                            color: .green
                        )
                    }
                    .padding(.horizontal, 20)
                    .offset(y: animationOffset + 20)
                    .opacity(animationOpacity * 0.8)
                    
                    // 비교 정보
                    CardView(cornerRadius: 16, shadowRadius: 8) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("분석 결과")
                                .font(AppTheme.getFont(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(result.comparison)
                                    .font(AppTheme.getFont(size: 16, weight: .light))
                                    .foregroundColor(.primary)
                                
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("• 전국 \(result.totalPopulation.formattedWithCommas)명 중 \(result.rank.formattedWithCommas)위")
                                        .font(AppTheme.getFont(size: 14, weight: .light))
                                        .foregroundColor(.secondary)
                                    
                                    Text("• 상위 \(result.percentile.formattedPercent)에 해당")
                                        .font(AppTheme.getFont(size: 14, weight: .light))
                                        .foregroundColor(.secondary)
                                    
                                    Text("• \(result.category.rawValue) 자산 그룹")
                                        .font(AppTheme.getFont(size: 14, weight: .light))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .offset(y: animationOffset + 40)
                    .opacity(animationOpacity * 0.6)
                    
                    // 공유 버튼
                    Button(action: {
                        shareResult()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                            Text("결과 공유하기")
                                .font(AppTheme.getFont(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppTheme.primaryGradient)
                        .cornerRadius(AppTheme.cornerRadius)
                    }
                    .padding(.horizontal, 20)
                    .offset(y: animationOffset + 60)
                    .opacity(animationOpacity * 0.4)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            animationOffset = 0
            animationOpacity = 1
        }
    }
    
    private func shareResult() {
        let shareText = """
        💰 자산랭킹 결과
        
        순자산액: ₩\(result.netWorth.formattedWithCommas)
        전국 순위: \(result.rank.formattedWithCommas)위
        상위 비율: \(result.percentile.formattedPercent)
        자산 그룹: \(result.category.rawValue)
        
        \(result.description)
        
        #자산랭킹 #AssetRank
        """
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
}

#Preview {
    ResultView(
        result: AssetRankingResult(
            netWorth: 150000000,
            percentile: 15.5,
            rank: 8000000,
            totalPopulation: 52000000,
            averageNetWorth: 65000000,
            medianNetWorth: 45000000,
            category: .top25,
            description: "전국 상위 25%의 자산을 보유하고 있습니다",
            comparison: "평균 대비 2.3배 높습니다"
        ),
        onBack: {}
    )
}
