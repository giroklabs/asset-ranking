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
                            VStack(spacing: 16) {
                                Text("나의 자산 순위를 확인해보세요")
                                    .font(AppTheme.getFont(size: 18, weight: .light))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // 자산 입력 카드
                            CardView(cornerRadius: 16, shadowRadius: 8) {
                                VStack(spacing: 24) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("순자산액 입력")
                                            .font(AppTheme.getFont(size: 20, weight: .semibold))
                                            .foregroundColor(.primary)
                                        
                                        Text("총 자산에서 부채를 뺀 순자산액을 입력해주세요")
                                            .font(AppTheme.getFont(size: 14, weight: .light))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    VStack(spacing: 16) {
                                        HStack {
                                            Text("₩")
                                                .font(AppTheme.getFont(size: 24, weight: .bold))
                                                .foregroundColor(.primary)
                                            
                                            TextField("0", text: $netWorth)
                                                .font(AppTheme.getFont(size: 24, weight: .bold))
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.trailing)
                                                .textFieldStyle(PlainTextFieldStyle())
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(.systemGray6))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(.systemGray4), lineWidth: 0.5)
                                        )
                                        
                                        // 한국어 단위 변환 표시
                                        if !netWorth.isEmpty {
                                            HStack {
                                                Spacer()
                                                Text(formattedKoreanAmount)
                                                    .font(AppTheme.getFont(size: 16, weight: .medium))
                                                    .foregroundColor(.blue)
                                                    .padding(.top, 8)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // 확인 버튼
                            Button(action: {
                                if netWorth.isEmpty {
                                    return
                                }
                                checkRanking()
                            }) {
                                Text("순위 확인하기")
                                    .font(AppTheme.getFont(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(AppTheme.primaryGradient)
                                    .cornerRadius(AppTheme.cornerRadius)
                            }
                            .disabled(isLoading)
                            .opacity(isLoading ? 0.6 : 1.0)
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