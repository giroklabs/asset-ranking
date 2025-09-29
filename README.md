# 자산랭킹 (AssetRank) 💰

한국 기준 순자산액을 입력하면 현재 기준 자산랭킹을 알려주는 iOS 앱입니다.

## 주요 기능

- **순자산액 입력**: 총 자산에서 부채를 뺀 순자산액을 입력
- **실시간 랭킹 계산**: 한국은행 API를 활용한 정확한 순위 계산
- **상세 통계 제공**: 평균, 중간값, 상위 비율 등 상세 정보
- **결과 공유**: 계산된 결과를 소셜미디어로 공유
- **아름다운 UI**: 참고 디자인을 기반으로 한 모던한 인터페이스

## 기술 스택

- **언어**: Swift 5.0
- **프레임워크**: SwiftUI
- **최소 지원 버전**: iOS 15.0
- **의존성 관리**: CocoaPods
- **API**: 한국은행 경제통계시스템 API

## 설치 및 실행

### 1. 프로젝트 클론
```bash
git clone [repository-url]
cd asset-ranking
```

### 2. CocoaPods 설치
```bash
pod install
```

### 3. Xcode에서 실행
```bash
open AssetRanking.xcworkspace
```

## 프로젝트 구조

```
AssetRanking/
├── AssetRankingApp.swift          # 앱 진입점
├── ContentView.swift              # 메인 화면
├── ResultView.swift               # 결과 화면
├── AppTheme.swift                 # 테마 및 스타일
├── Components.swift               # 재사용 가능한 컴포넌트
├── AssetModels.swift              # 데이터 모델
├── AssetRankingService.swift      # API 서비스
├── Assets.xcassets/               # 앱 아이콘 및 이미지
├── Info.plist                     # 앱 설정
└── Podfile                        # CocoaPods 의존성
```

## API 연동

### 한국은행 API
- **인증키**: 5RTMINGVGFOXMT0UHGJS
- **엔드포인트**: https://ecos.bok.or.kr/api
- **데이터**: 가계부채 및 자산 통계

### 사용 예시
```swift
AssetRankingService.shared.getRanking(for: 150000000) { result in
    if let result = result {
        print("순위: \(result.rank)위")
        print("상위 비율: \(result.percentile)%")
    }
}
```

## 디자인 시스템

### 컬러 팔레트
- **Primary**: Pink (#FF69B4)
- **Secondary**: Purple (#8A2BE2)
- **Success**: Green (#32CD32)
- **Warning**: Orange (#FFA500)
- **Error**: Red (#FF0000)

### 타이포그래피
- **폰트**: MaruBuri OTF Regular
- **크기**: 12pt ~ 32pt
- **가중치**: Light, Regular, Semibold, Bold

### 컴포넌트
- **CardView**: 그림자와 둥근 모서리가 있는 카드
- **GradientButton**: 그라데이션 배경 버튼
- **RankBadge**: 순위 표시 배지
- **LoadingView**: 로딩 인디케이터

## 자산 분포 데이터

현재 앱에서는 다음 기준으로 순위를 계산합니다:

| 상위 비율 | 순자산액 기준 |
|----------|-------------|
| 1%       | 10억원 이상  |
| 5%       | 5억원 이상   |
| 10%      | 3억원 이상   |
| 25%      | 1.5억원 이상 |
| 50%      | 8천만원 이상 |
| 75%      | 4천만원 이상 |
| 90%      | 2천만원 이상 |
| 95%      | 1천만원 이상 |

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 개발자

**GIROK Labs.**
- 이메일: contact@giroklabs.com
- 웹사이트: https://giroklabs.com

## 버전 히스토리

### v1.0.0 (2024-01-01)
- 초기 릴리스
- 순자산액 입력 및 랭킹 계산 기능
- 한국은행 API 연동
- 결과 공유 기능
- 모던한 UI/UX 디자인
