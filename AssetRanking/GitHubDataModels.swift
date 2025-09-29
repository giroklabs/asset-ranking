import Foundation

// MARK: - GitHub 데이터 모델
struct GitHubAssetData: Codable {
    let lastUpdated: String
    let dataSource: String
    let version: String
    let statistics: AssetStatistics
    let percentiles: [String: Int]
    let monthlyData: [MonthlyData]
    let fallback: FallbackConfig
}

struct AssetStatistics: Codable {
    let totalPopulation: Int
    let averageNetWorth: Int
    let medianNetWorth: Int
    let averageDebt: Int
    let averageAssets: Int
}

struct MonthlyData: Codable {
    let date: String
    let averageDebt: Int
    let averageAssets: Int
    let netWorth: Int
    let debtRatio: Double
}

struct FallbackConfig: Codable {
    let enabled: Bool
    let message: String
}

// MARK: - GitHub 데이터 매니저
class GitHubDataManager {
    static let shared = GitHubDataManager()
    
    private let githubURL = "https://raw.githubusercontent.com/giroklabs/asset-ranking/main/data/asset-distribution.json"
    private let localFallbackURL = Bundle.main.url(forResource: "asset-distribution", withExtension: "json")
    
    private init() {}
    
    // MARK: - GitHub에서 데이터 로드
    func fetchAssetData(completion: @escaping (GitHubAssetData?) -> Void) {
        guard let url = URL(string: githubURL) else {
            print("❌ GitHub URL 생성 실패")
            loadLocalFallback(completion: completion)
            return
        }
        
        print("🔄 GitHub에서 자산 데이터 로드 중...")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ GitHub 데이터 로드 실패: \(error.localizedDescription)")
                self.loadLocalFallback(completion: completion)
                return
            }
            
            guard let data = data else {
                print("❌ GitHub 데이터 없음")
                self.loadLocalFallback(completion: completion)
                return
            }
            
            do {
                let assetData = try JSONDecoder().decode(GitHubAssetData.self, from: data)
                print("✅ GitHub 데이터 로드 성공: \(assetData.lastUpdated)")
                completion(assetData)
            } catch {
                print("❌ GitHub 데이터 파싱 실패: \(error.localizedDescription)")
                self.loadLocalFallback(completion: completion)
            }
        }.resume()
    }
    
    // MARK: - 로컬 폴백 데이터 로드
    private func loadLocalFallback(completion: @escaping (GitHubAssetData?) -> Void) {
        guard let localURL = localFallbackURL else {
            print("❌ 로컬 폴백 데이터 없음")
            completion(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: localURL)
            let assetData = try JSONDecoder().decode(GitHubAssetData.self, from: data)
            print("✅ 로컬 폴백 데이터 로드 성공")
            completion(assetData)
        } catch {
            print("❌ 로컬 폴백 데이터 로드 실패: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    // MARK: - GitHub 데이터를 AssetDistributionData로 변환
    func convertToAssetDistributionData(_ githubData: GitHubAssetData) {
        // 통계 데이터 업데이트
        AssetDistributionData.totalPopulation = githubData.statistics.totalPopulation
        AssetDistributionData.averageNetWorth = githubData.statistics.averageNetWorth
        AssetDistributionData.medianNetWorth = githubData.statistics.medianNetWorth
        
        // 백분위 데이터 업데이트
        var newPercentiles: [Double: Int] = [:]
        for (key, value) in githubData.percentiles {
            if let percentile = Double(key) {
                newPercentiles[percentile] = value
            }
        }
        AssetDistributionData.netWorthPercentiles = newPercentiles
        
        print("✅ GitHub 데이터로 자산 분포 업데이트 완료")
        print("📊 평균 순자산: \(githubData.statistics.averageNetWorth.formattedKorean)")
        print("📊 중간값 순자산: \(githubData.statistics.medianNetWorth.formattedKorean)")
    }
}
