import SwiftUI

struct ContentView: View {
    @State private var netWorth: String = ""
    @State private var showingResult = false
    @State private var isLoading = false
    @State private var rankingResult: AssetRankingResult?
    @State private var isKeyboardVisible = false
    @State private var searchHistory: [SearchHistory] = []
    @State private var isFromHistory = false  // 히스토리에서 클릭했는지 여부
    
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
                        // 히스토리 로드
                        searchHistory = HistoryManager.shared.getHistory()
                    }
                
                VStack(spacing: 0) {
                    TopSeparator()
                        .padding(.top, 4)
                    
                    if !showingResult {
                        VStack(spacing: 0) {
                            // 고정 영역
                            VStack(spacing: 32) {
                                Spacer()
                                    .frame(height: 20)
                                
                                // 앱 타이틀
                            VStack(spacing: 16) {
                                Text("나의 자산 순위를 확인해보세요")
                                    .font(AppTheme.getFont(size: 24, weight: .bold))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("실시간 한국은행 데이터 기반")
                                    .font(AppTheme.getFont(size: 14, weight: .light))
                                    .foregroundColor(.secondary)
                                    .opacity(0.8)
                            }
                            
                            // 자산 입력 섹션
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("순자산액 입력")
                                        .font(AppTheme.getFont(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text("총 자산에서 부채를 뺀 순자산액을 입력해주세요")
                                        .font(AppTheme.getFont(size: 13, weight: .light))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 12) {
                                    // 입력 필드
                                    HStack {
                                        Text("₩")
                                            .font(AppTheme.getFont(size: 24, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        TextField("0", text: $netWorth)
                                            .font(AppTheme.getFont(size: 24, weight: .bold))
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.trailing)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .foregroundColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                                    
                                    // 한국어 단위 변환 표시
                                    if !netWorth.isEmpty {
                                        HStack {
                                            Spacer()
                                            Text(formattedKoreanAmount)
                                                .font(AppTheme.getFont(size: 15, weight: .medium))
                                                .foregroundColor(.blue)
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
                                HStack(spacing: 8) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.9)
                                    }
                                    
                                    Text(isLoading ? "분석 중..." : "순위 확인하기")
                                        .font(AppTheme.getFont(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.2, blue: 0.5),
                                            Color(red: 0.6, green: 0.3, blue: 0.9)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color(red: 1.0, green: 0.2, blue: 0.5).opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(isLoading || netWorth.isEmpty)
                            .opacity((isLoading || netWorth.isEmpty) ? 0.6 : 1.0)
                            .padding(.horizontal, 20)
                            }
                            
                            // 검색 히스토리 (스크롤 가능 영역)
                            if !searchHistory.isEmpty {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("최근 검색 기록")
                                            .font(AppTheme.getFont(size: 14, weight: .semibold))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            HistoryManager.shared.clearHistory()
                                            searchHistory = []
                                        }) {
                                            Text("전체 삭제")
                                                .font(AppTheme.getFont(size: 12, weight: .light))
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 24)
                                    .padding(.bottom, 12)
                                    
                                    ScrollView {
                                        VStack(spacing: 8) {
                                            ForEach(searchHistory) { history in
                                                Button(action: {
                                                    netWorth = "\(history.netWorth)"
                                                    isFromHistory = true  // 히스토리에서 클릭한 것으로 표시
                                                    checkRanking()
                                                }) {
                                                    HStack(spacing: 12) {
                                                        VStack(alignment: .leading, spacing: 4) {
                                                            Text(history.netWorth.formattedKorean)
                                                                .font(AppTheme.getFont(size: 15, weight: .semibold))
                                                                .foregroundColor(.primary)
                                                            
                                                            Text(formatDate(history.date))
                                                                .font(AppTheme.getFont(size: 12, weight: .light))
                                                                .foregroundColor(.secondary)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text(history.percentile <= 50 ? "상위 \(String(format: "%.2f", history.percentile))%" : "하위 \(String(format: "%.2f", 100 - history.percentile))%")
                                                            .font(AppTheme.getFont(size: 13, weight: .medium))
                                                            .foregroundColor(.blue)
                                                    }
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 12)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color(.systemBackground))
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color(.systemGray5), lineWidth: 1)
                                                    )
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 20)
                                    }
                                }
                            } else {
                                Spacer()
                            }
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
                    
                    // 히스토리에서 클릭한 경우가 아닐 때만 저장
                    if !self.isFromHistory {
                        HistoryManager.shared.saveHistory(netWorth: result.netWorth, percentile: result.percentile)
                        self.searchHistory = HistoryManager.shared.getHistory()
                    }
                    
                    // 플래그 리셋
                    self.isFromHistory = false
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy년 MM월 dd일 HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}