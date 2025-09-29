import SwiftUI

struct ContentView: View {
    @State private var netWorth: String = ""
    @State private var showingResult = false
    @State private var isLoading = false
    @State private var rankingResult: AssetRankingResult?
    @State private var isKeyboardVisible = false
    
    // 한국어 단위 변환된 금액
    private var formattedKoreanAmount: String {
        let cleanedInput = netWorth.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
        guard let amount = Int(cleanedInput), amount > 0 else {
            return ""
        }
        return amount.formattedKorean
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // 배경 그라데이션
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                    .onAppear {
                        // 폰트 디버그 정보 출력 (README 권장)
                        AppTheme.debugFontInfo()
                    }
                
                VStack(spacing: 0) {
                    TopSeparator()
                        .padding(.top, 4)
                    
                    if !showingResult {
                        VStack(spacing: 32) {
                            Spacer()
                            
                            // 앱 타이틀
                            VStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("나의 자산 순위를")
                                        .font(AppTheme.getFont(size: 20, weight: .light))
                                        .foregroundColor(.primary.opacity(0.8))
                                    
                                    Text("확인해보세요")
                                        .font(AppTheme.getFont(size: 20, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Text("실시간 한국은행 데이터 기반")
                                    .font(AppTheme.getFont(size: 12, weight: .light))
                                    .foregroundColor(.secondary)
                                    .opacity(0.7)
                            }
                            
                            // 자산 입력 카드
                            CardView(cornerRadius: 20, shadowRadius: 12) {
                                VStack(spacing: 28) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(AppTheme.primary)
                                            
                                            Text("순자산액 입력")
                                                .font(AppTheme.getFont(size: 20, weight: .semibold))
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Text("총 자산에서 부채를 뺀 순자산액을 입력해주세요")
                                            .font(AppTheme.getFont(size: 14, weight: .light))
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    VStack(spacing: 20) {
                                        HStack {
                                            Text("₩")
                                                .font(AppTheme.getFont(size: 28, weight: .bold))
                                                .foregroundColor(AppTheme.primary)
                                                .padding(.leading, 4)
                                            
                                            TextField("0", text: $netWorth)
                                                .font(AppTheme.getFont(size: 28, weight: .bold))
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.trailing)
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .foregroundColor(AppTheme.primary)
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(.systemGray6),
                                                            Color(.systemGray5)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            AppTheme.primary.opacity(0.3),
                                                            AppTheme.primary.opacity(0.1)
                                                        ]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ),
                                                    lineWidth: 1.5
                                                )
                                        )
                                        
                                        // 한국어 단위 변환 표시
                                        if !netWorth.isEmpty {
                                            HStack {
                                                Spacer()
                                                HStack(spacing: 6) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.system(size: 12, weight: .medium))
                                                        .foregroundColor(AppTheme.success)
                                                    
                                                    Text(formattedKoreanAmount)
                                                        .font(AppTheme.getFont(size: 16, weight: .semibold))
                                                        .foregroundColor(AppTheme.success)
                                                }
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(AppTheme.success.opacity(0.1))
                                                )
                                                .padding(.top, 8)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // 확인 버튼
                            VStack(spacing: 16) {
                                Button(action: {
                                    if netWorth.isEmpty {
                                        return
                                    }
                                    checkRanking()
                                }) {
                                    HStack(spacing: 8) {
                                        if isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "magnifyingglass")
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                        
                                        Text(isLoading ? "분석 중..." : "순위 확인하기")
                                            .font(AppTheme.getFont(size: 18, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [AppTheme.primary, AppTheme.primary.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(28)
                                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                                .disabled(isLoading || netWorth.isEmpty)
                                .opacity((isLoading || netWorth.isEmpty) ? 0.6 : 1.0)
                                .scaleEffect(isLoading ? 0.98 : 1.0)
                                .animation(.easeInOut(duration: 0.1), value: isLoading)
                                
                                // 하단 안내 텍스트
                                Text("실시간 한국은행 데이터 기반")
                                    .font(AppTheme.getFont(size: 12, weight: .light))
                                    .foregroundColor(.secondary)
                                    .opacity(0.7)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                    } else if let result = rankingResult {
                        ResultView(
                            result: result,
                            onBack: {
                                showingResult = false
                                rankingResult = nil
                                netWorth = ""
                            }
                        )
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: AppTitleView(baseSize: 20)
            )
            .onTapGesture {
                // 키보드 숨기기
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                isKeyboardVisible = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                isKeyboardVisible = false
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    SignatureView()
                    TestAdBannerPlaceholder()
                }
            }
        }
    }
    
    private func checkRanking() {
        // 이미 로딩 중이면 무시
        guard !isLoading else {
            return
        }
        
        // 입력값 정리 (공백, 쉼표 제거)
        let cleanedInput = netWorth.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
        
        guard let amount = Int(cleanedInput), amount > 0 else {
            return
        }
        
        // 상태 초기화
        showingResult = false
        rankingResult = nil
        isLoading = true
        
        // 한국은행 API 호출 및 랭킹 계산 (실제 데이터 사용)
        AssetRankingService.shared.getRanking(for: amount) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                if let result = result {
                    self.rankingResult = result
                    self.showingResult = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}