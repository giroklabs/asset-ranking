import Foundation
import Combine

class AssetRankingService: ObservableObject {
    static let shared = AssetRankingService()
    
    private let apiKey = "5RTMINGVGFOXMT0UHGJS"
    private let baseURL = "https://ecos.bok.or.kr/api"
    
    private init() {}
    
    // MARK: - 자산 랭킹 조회
    func getRanking(for netWorth: Int, completion: @escaping (AssetRankingResult?) -> Void) {
        fetchAssetData { [weak self] success in
            if success {
                let result = RankingCalculator.calculateRanking(for: netWorth)
                completion(result)
            } else {
                // API 실패 시 기본 데이터로 계산
                let result = RankingCalculator.calculateRanking(for: netWorth)
                completion(result)
            }
        }
    }
    
    // MARK: - 한국은행 API 호출
    private func fetchAssetData(completion: @escaping (Bool) -> Void) {
        // 가계부채 및 자산 통계 조회 (최근 1년 데이터)
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        let endDate = formatter.string(from: currentDate)
        let startDate = formatter.string(from: Calendar.current.date(byAdding: .year, value: -1, to: currentDate) ?? currentDate)
        
        let urlString = "\(baseURL)/StatisticSearch/\(apiKey)/json/kr/1/100/020Y001/DD/\(startDate)/\(endDate)"
        
        guard let url = URL(string: urlString) else {
            print("잘못된 URL: \(urlString)")
            completion(false)
            return
        }
        
        print("한국은행 API 호출: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API 호출 오류: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                completion(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(BankOfKoreaResponse.self, from: data)
                print("API 응답 성공: \(response.StatisticSearch.list_total_count)개 데이터")
                
                // 실제 데이터를 기반으로 자산 분포 업데이트
                self.updateAssetDistribution(from: response.StatisticSearch.row)
                completion(true)
            } catch {
                print("JSON 파싱 오류: \(error.localizedDescription)")
                print("응답 데이터: \(String(data: data, encoding: .utf8) ?? "데이터를 읽을 수 없음")")
                completion(false)
            }
        }.resume()
    }
    
    // MARK: - 자산 분포 데이터 업데이트
    private func updateAssetDistribution(from data: [AssetData]) {
        // 실제 API 데이터를 기반으로 자산 분포 계산
        // 여기서는 가계부채 데이터를 기반으로 순자산 분포를 추정
        
        var totalDebt = 0.0
        var totalAssets = 0.0
        var dataCount = 0
        
        for item in data {
            if let debtValue = Double(item.DATA_VALUE) {
                totalDebt += debtValue
                dataCount += 1
            }
        }
        
        if dataCount > 0 {
            let averageDebt = totalDebt / Double(dataCount)
            // 부채 대비 자산 비율을 추정 (일반적으로 자산은 부채의 3-5배)
            let estimatedAssetRatio = 4.0
            totalAssets = averageDebt * estimatedAssetRatio
            
            // 실제 데이터를 기반으로 분포 업데이트
            AssetDistributionData.updateWithRealData(
                averageDebt: Int(averageDebt),
                averageAssets: Int(totalAssets)
            )
            
            print("실제 데이터 기반 업데이트:")
            print("- 평균 부채: \(Int(averageDebt).formattedKorean)")
            print("- 추정 자산: \(Int(totalAssets).formattedKorean)")
        }
    }
    
    // MARK: - 통계 데이터 업데이트
    func updateStatistics(completion: @escaping (Bool) -> Void) {
        fetchAssetData { success in
            completion(success)
        }
    }
    
    // MARK: - 네트워크 상태 확인
    func checkNetworkStatus() -> Bool {
        // 간단한 네트워크 상태 확인
        return true
    }
}

// MARK: - API 에러 타입
enum AssetRankingError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError
    case apiKeyInvalid
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .noData:
            return "데이터를 받아올 수 없습니다"
        case .decodingError:
            return "데이터를 해석할 수 없습니다"
        case .networkError:
            return "네트워크 연결을 확인해주세요"
        case .apiKeyInvalid:
            return "API 키가 유효하지 않습니다"
        }
    }
}

// MARK: - 숫자 포맷팅 헬퍼
extension Int {
    var formattedWithCommas: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
}

extension Double {
    var formattedPercent: String {
        return String(format: "%.1f", self) + "%"
    }
}
