import Foundation

// MARK: - 한국 숫자 포맷팅 확장
extension Int {
    var formattedKorean: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        
        if self >= 100000000 {
            let 억 = self / 100000000
            let 천만 = (self % 100000000) / 10000000
            if 천만 > 0 {
                return "\(억)억 \(천만)천만원"
            } else {
                return "\(억)억원"
            }
        } else if self >= 10000 {
            let 만 = self / 10000
            let 천 = (self % 10000) / 1000
            if 천 > 0 {
                return "\(만)만 \(천)천원"
            } else {
                return "\(만)만원"
            }
        } else {
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)원"
        }
    }
}

// MARK: - 자산 랭킹 결과 모델
struct AssetRankingResult: Codable {
    let netWorth: Int
    let percentile: Double
    let rank: Int
    let totalPopulation: Int
    let averageNetWorth: Int
    let medianNetWorth: Int
    let category: AssetCategory
    let description: String
    let comparison: String
}

// MARK: - 자산 카테고리
enum AssetCategory: String, CaseIterable, Codable {
    case top1 = "상위 1%"
    case top10 = "상위 10%"
    case top25 = "상위 25%"
    case top50 = "상위 50%"
    case bottom50 = "하위 50%"
    case bottom25 = "하위 25%"
    
    var color: String {
        switch self {
        case .top1: return "red"
        case .top10: return "orange"
        case .top25: return "yellow"
        case .top50: return "blue"
        case .bottom50: return "green"
        case .bottom25: return "gray"
        }
    }
    
    var description: String {
        switch self {
        case .top1: return "전국 상위 1%의 자산을 보유하고 있습니다"
        case .top10: return "전국 상위 10%의 자산을 보유하고 있습니다"
        case .top25: return "전국 상위 25%의 자산을 보유하고 있습니다"
        case .top50: return "전국 상위 50%의 자산을 보유하고 있습니다"
        case .bottom50: return "전국 하위 50%의 자산을 보유하고 있습니다"
        case .bottom25: return "전국 하위 25%의 자산을 보유하고 있습니다"
        }
    }
}

// MARK: - 한국은행 API 응답 모델
struct BankOfKoreaResponse: Codable {
    let StatisticSearch: StatisticSearch
}

struct StatisticSearch: Codable {
    let list_total_count: Int
    let row: [AssetData]
}

struct AssetData: Codable {
    let TIME: String
    let ITEM_NAME1: String
    let ITEM_NAME2: String
    let ITEM_NAME3: String
    let ITEM_NAME4: String
    let ITEM_NAME5: String
    let ITEM_NAME6: String
    let ITEM_NAME7: String
    let ITEM_NAME8: String
    let ITEM_NAME9: String
    let ITEM_NAME10: String
    let ITEM_NAME11: String
    let ITEM_NAME12: String
    let ITEM_NAME13: String
    let ITEM_NAME14: String
    let ITEM_NAME15: String
    let ITEM_NAME16: String
    let ITEM_NAME17: String
    let ITEM_NAME18: String
    let ITEM_NAME19: String
    let ITEM_NAME20: String
    let ITEM_NAME21: String
    let ITEM_NAME22: String
    let ITEM_NAME23: String
    let ITEM_NAME24: String
    let ITEM_NAME25: String
    let ITEM_NAME26: String
    let ITEM_NAME27: String
    let ITEM_NAME28: String
    let ITEM_NAME29: String
    let ITEM_NAME30: String
    let ITEM_NAME31: String
    let ITEM_NAME32: String
    let ITEM_NAME33: String
    let ITEM_NAME34: String
    let ITEM_NAME35: String
    let ITEM_NAME36: String
    let ITEM_NAME37: String
    let ITEM_NAME38: String
    let ITEM_NAME39: String
    let ITEM_NAME40: String
    let ITEM_NAME41: String
    let ITEM_NAME42: String
    let ITEM_NAME43: String
    let ITEM_NAME44: String
    let ITEM_NAME45: String
    let ITEM_NAME46: String
    let ITEM_NAME47: String
    let ITEM_NAME48: String
    let ITEM_NAME49: String
    let ITEM_NAME50: String
    let ITEM_NAME51: String
    let ITEM_NAME52: String
    let ITEM_NAME53: String
    let ITEM_NAME54: String
    let ITEM_NAME55: String
    let ITEM_NAME56: String
    let ITEM_NAME57: String
    let ITEM_NAME58: String
    let ITEM_NAME59: String
    let ITEM_NAME60: String
    let ITEM_NAME61: String
    let ITEM_NAME62: String
    let ITEM_NAME63: String
    let ITEM_NAME64: String
    let ITEM_NAME65: String
    let ITEM_NAME66: String
    let ITEM_NAME67: String
    let ITEM_NAME68: String
    let ITEM_NAME69: String
    let ITEM_NAME70: String
    let ITEM_NAME71: String
    let ITEM_NAME72: String
    let ITEM_NAME73: String
    let ITEM_NAME74: String
    let ITEM_NAME75: String
    let ITEM_NAME76: String
    let ITEM_NAME77: String
    let ITEM_NAME78: String
    let ITEM_NAME79: String
    let ITEM_NAME80: String
    let ITEM_NAME81: String
    let ITEM_NAME82: String
    let ITEM_NAME83: String
    let ITEM_NAME84: String
    let ITEM_NAME85: String
    let ITEM_NAME86: String
    let ITEM_NAME87: String
    let ITEM_NAME88: String
    let ITEM_NAME89: String
    let ITEM_NAME90: String
    let ITEM_NAME91: String
    let ITEM_NAME92: String
    let ITEM_NAME93: String
    let ITEM_NAME94: String
    let ITEM_NAME95: String
    let ITEM_NAME96: String
    let ITEM_NAME97: String
    let ITEM_NAME98: String
    let ITEM_NAME99: String
    let ITEM_NAME100: String
    let DATA_VALUE: String
}

// MARK: - 자산 분포 데이터 (실제 데이터 기반)
struct AssetDistributionData {
    static var netWorthPercentiles: [Double: Int] = [
        0.01: 1000000000,    // 상위 1%: 10억원
        0.05: 500000000,     // 상위 5%: 5억원
        0.10: 300000000,     // 상위 10%: 3억원
        0.25: 150000000,     // 상위 25%: 1.5억원
        0.50: 80000000,      // 상위 50%: 8천만원
        0.75: 40000000,      // 상위 75%: 4천만원
        0.90: 20000000,      // 상위 90%: 2천만원
        0.95: 10000000,      // 상위 95%: 1천만원
        0.99: 5000000        // 상위 99%: 5백만원
    ]
    
    static var averageNetWorth = 65000000  // 평균 순자산: 6천5백만원
    static var medianNetWorth = 45000000   // 중간값 순자산: 4천5백만원
    static let totalPopulation = 52000000  // 총 인구: 5천2백만명
    
    // 실제 API 데이터를 기반으로 분포 업데이트
    static func updateWithRealData(averageDebt: Int, averageAssets: Int) {
        let netWorth = averageAssets - averageDebt
        
        // 실제 데이터를 기반으로 분포 재계산
        // 가계부채 통계를 기반으로 순자산 분포 추정
        let debtRatio = Double(averageDebt) / Double(averageAssets)
        
        // 부채 비율에 따라 분포 조정
        let adjustmentFactor = 1.0 + (0.5 - debtRatio) * 0.5 // 부채 비율이 낮을수록 자산이 더 높음
        
        netWorthPercentiles = [
            0.01: Int(Double(netWorth) * 15.0 * adjustmentFactor),    // 상위 1%
            0.05: Int(Double(netWorth) * 8.0 * adjustmentFactor),     // 상위 5%
            0.10: Int(Double(netWorth) * 5.0 * adjustmentFactor),     // 상위 10%
            0.25: Int(Double(netWorth) * 2.5 * adjustmentFactor),     // 상위 25%
            0.50: Int(Double(netWorth) * 1.2 * adjustmentFactor),     // 상위 50%
            0.75: Int(Double(netWorth) * 0.6 * adjustmentFactor),     // 상위 75%
            0.90: Int(Double(netWorth) * 0.3 * adjustmentFactor),     // 상위 90%
            0.95: Int(Double(netWorth) * 0.15 * adjustmentFactor),    // 상위 95%
            0.99: Int(Double(netWorth) * 0.05 * adjustmentFactor)     // 상위 99%
        ]
        
        averageNetWorth = netWorth
        medianNetWorth = Int(Double(netWorth) * 0.7) // 중간값은 평균의 70% 정도
        
        print("자산 분포 업데이트 완료:")
        print("- 평균 순자산: \(averageNetWorth.formattedKorean)")
        print("- 중간값 순자산: \(medianNetWorth.formattedKorean)")
    }
}

// MARK: - 랭킹 계산 헬퍼
struct RankingCalculator {
    static func calculateRanking(for netWorth: Int) -> AssetRankingResult {
        let percentile = calculatePercentile(for: netWorth)
        let category = determineCategory(percentile: percentile)
        let rank = calculateRank(percentile: percentile)
        
        return AssetRankingResult(
            netWorth: netWorth,
            percentile: percentile,
            rank: rank,
            totalPopulation: AssetDistributionData.totalPopulation,
            averageNetWorth: AssetDistributionData.averageNetWorth,
            medianNetWorth: AssetDistributionData.medianNetWorth,
            category: category,
            description: category.description,
            comparison: generateComparison(netWorth: netWorth, percentile: percentile)
        )
    }
    
    private static func calculatePercentile(for netWorth: Int) -> Double {
        let sortedPercentiles = AssetDistributionData.netWorthPercentiles.sorted { $0.key < $1.key }
        
        for (percentile, threshold) in sortedPercentiles {
            if netWorth >= threshold {
                return percentile * 100
            }
        }
        
        return 99.0 // 상위 1% 미만
    }
    
    private static func determineCategory(percentile: Double) -> AssetCategory {
        switch percentile {
        case 0..<1:
            return .top1
        case 1..<10:
            return .top10
        case 10..<25:
            return .top25
        case 25..<50:
            return .top50
        case 50..<75:
            return .bottom50
        default:
            return .bottom25
        }
    }
    
    private static func calculateRank(percentile: Double) -> Int {
        return Int((100 - percentile) * Double(AssetDistributionData.totalPopulation) / 100)
    }
    
    private static func generateComparison(netWorth: Int, percentile: Double) -> String {
        let average = AssetDistributionData.averageNetWorth
        let median = AssetDistributionData.medianNetWorth
        
        if netWorth > average {
            let ratio = Double(netWorth) / Double(average)
            return "평균 대비 \(String(format: "%.1f", ratio))배 높습니다"
        } else if netWorth > median {
            return "평균보다는 낮지만 중간값보다는 높습니다"
        } else {
            let ratio = Double(median) / Double(netWorth)
            return "중간값 대비 \(String(format: "%.1f", ratio))배 낮습니다"
        }
    }
}
