import SwiftUI

struct ContentView: View {
    @State private var netWorth: String = ""
    @State private var showingResult = false
    @State private var isLoading = false
    @State private var rankingResult: AssetRankingResult?
    @State private var isKeyboardVisible = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // 배경 그라데이션
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TopSeparator()
                        .padding(.top, 4)
                    
                    if !showingResult {
                        VStack(spacing: 32) {
                            Spacer()
                            
                            // 앱 타이틀
                            VStack(spacing: 16) {
                                AppTitleView(baseSize: 32)
                                
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
                                        
                                        Text("예: 1억원 = 100,000,000")
                                            .font(AppTheme.getFont(size: 12, weight: .light))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // 확인 버튼
                            Button(action: {
                                checkRanking()
                            }) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.title3)
                                    }
                                    Text("순위 확인하기")
                                        .font(AppTheme.getFont(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppTheme.primaryGradient)
                                .cornerRadius(AppTheme.cornerRadius)
                            }
                            .disabled(netWorth.isEmpty || isLoading)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                    } else if let result = rankingResult {
                        ResultView(
                            result: result,
                            onBack: {
                                showingResult = false
                                rankingResult = nil
                            }
                        )
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: AppTitleView(baseSize: 20)
                    .padding(.top, 12)
            )
        }
        .onAppear {
            // 앱 시작 시 초기화
        }
        .onTapGesture {
            // 배경 탭 시 키보드 내리기
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
        .safeAreaInset(edge: .bottom) {
            if !isKeyboardVisible {
                VStack(spacing: 4) {
                    SignatureView()
                    TestAdBannerPlaceholder()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                }
            }
        }
    }
    
    private func checkRanking() {
        guard let amount = Int(netWorth.replacingOccurrences(of: ",", with: "")), amount > 0 else {
            return
        }
        
        isLoading = true
        
        // 한국은행 API 호출 및 랭킹 계산 (실제 데이터 사용)
        AssetRankingService.shared.getRanking(for: amount) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                if let result = result {
                    self.rankingResult = result
                    self.showingResult = true
                } else {
                    // API 실패 시 에러 메시지 표시
                    print("자산 랭킹 계산 실패")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
