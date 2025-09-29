# MinimalPrint 폰트 적용 가이드

이 문서는 MinimalPrint 앱에서 MaruBuri 폰트를 적용하는 방법과 관련 기술적 세부사항을 설명합니다.

## 📋 개요

MinimalPrint 앱은 모든 텍스트에 **MaruBuriOTF Regular** 폰트를 사용하여 일관된 타이포그래피를 제공합니다.

## 🎯 적용된 폰트

- **폰트 이름**: `MaruBuriOTF Regular`
- **파일 형식**: OTF (OpenType Font)
- **적용 범위**: 앱 내 모든 텍스트 요소

## 📁 폰트 파일 구조

```
MinimalPrint/
├── MinimalPrint/
│   ├── MaruBuri-Light.ttf
│   ├── MaruBuri-Regular.ttf
│   ├── MaruBuri-Bold.ttf
│   ├── MaruBuri-SemiBold.ttf
│   ├── MaruBuri-ExtraLight.ttf
│   ├── MaruBuri-Light.otf
│   ├── MaruBuri-Regular.otf
│   ├── MaruBuri-Bold.otf
│   ├── MaruBuri-SemiBold.otf
│   └── MaruBuri-ExtraLight.otf
```

## ⚙️ 설정 방법

### 1. Info.plist 설정

`Info.plist`에 모든 폰트 파일을 등록해야 합니다:

```xml
<key>UIAppFonts</key>
<array>
    <string>MaruBuri-Light.ttf</string>
    <string>MaruBuri-Regular.ttf</string>
    <string>MaruBuri-Bold.ttf</string>
    <string>MaruBuri-SemiBold.ttf</string>
    <string>MaruBuri-ExtraLight.ttf</string>
    <string>MaruBuri-Light.otf</string>
    <string>MaruBuri-Regular.otf</string>
    <string>MaruBuri-Bold.otf</string>
    <string>MaruBuri-SemiBold.otf</string>
    <string>MaruBuri-ExtraLight.otf</string>
</array>
```

### 2. SwiftUI에서 폰트 적용

#### 기본 패턴
```swift
Text("텍스트")
    .font(UIFont(name: "MaruBuriOTF Regular", size: 16) != nil ? 
          Font(UIFont(name: "MaruBuriOTF Regular", size: 16)!) : 
          .system(size: 16))
```

#### 헬퍼 함수 사용 (권장)
```swift
// Tokens.swift에 정의된 헬퍼 함수
static func maruBuriFont(size: CGFloat) -> Font {
    if let font = UIFont(name: "MaruBuriOTF Regular", size: size) {
        return Font(font)
    }
    return .system(size: size)
}

// 사용 예시
Text("텍스트")
    .font(Tokens.maruBuriFont(size: 16))
```

## 🎨 적용된 텍스트 요소

### 1. 헤더 섹션
- **제목**: "삶의기록" (32pt)
- **부제목**: "내 삶의 아름다운 순간을 기록으로" (16pt)

### 2. 이미지 선택 영역
- **안내 텍스트**: "사진을 선택하세요" (16pt)

### 3. 설정 섹션
- **섹션 제목**: "세부 설정" (16pt)

### 4. 텍스트 입력 영역
- **라벨**: "문구를 입력하세요" (16pt)
- **텍스트 에디터**: 사용자 입력 텍스트 (16pt)

### 5. 필터 버튼
- **버튼 텍스트**: 필터 옵션들 (14pt)

### 6. 하단 액션 버튼
- **PDF 미리보기**: "PDF 미리보기" (16pt)
- **인쇄**: "인쇄" (16pt)

## 🔧 기술적 고려사항

### 1. 폰트 로딩 타이밍
- SwiftUI의 `static let` 선언은 앱 시작 시 한 번만 초기화됩니다
- 폰트 로딩이 완료되기 전에 초기화될 수 있어 폴백 폰트가 필요합니다

### 2. 폰트 이름 확인
```bash
# 폰트 파일에서 실제 PostScript 이름 확인
strings MaruBuri-Regular.otf | grep -i "MaruBuri"
```

### 3. 디버그 정보
앱에 폰트 로딩 상태를 확인할 수 있는 디버그 정보가 포함되어 있습니다:
- 폰트 로딩 상태
- 사용 가능한 MaruBuri 폰트 목록
- 폰트 파일 존재 여부

## 🚨 문제 해결

### 폰트가 적용되지 않는 경우

1. **폰트 파일 확인**
   ```bash
   # 앱 번들에 폰트 파일이 포함되었는지 확인
   find DerivedData -name "*.otf" -o -name "*.ttf"
   ```

2. **Info.plist 확인**
   - `UIAppFonts` 배열에 폰트 파일명이 정확히 등록되어 있는지 확인

3. **폰트 이름 확인**
   - PostScript 이름이 정확한지 확인 (`MaruBuriOTF Regular`)

4. **빌드 클린**
   ```bash
   # Xcode에서 Clean Build Folder 실행
   # 또는 터미널에서
   xcodebuild clean
   ```

### 폰트 로딩 실패 시
- 시스템 폰트로 자동 폴백됩니다
- 디버그 정보를 통해 문제를 진단할 수 있습니다

## 📱 사용자 경험

- **일관성**: 모든 텍스트에 동일한 폰트 적용
- **가독성**: MaruBuri 폰트의 우수한 한글 가독성
- **안정성**: 폰트 로딩 실패 시 시스템 폰트로 폴백

## 🔄 업데이트 이력

- **v1.0**: 초기 MaruBuri 폰트 적용
- **v1.1**: 모든 텍스트 요소에 폰트 적용 완료
- **v1.2**: 폰트 로딩 안정성 개선 및 디버그 정보 추가

---

**참고**: 이 가이드는 MinimalPrint 앱의 폰트 적용 방식을 문서화한 것입니다. 다른 프로젝트에서 참고할 때는 프로젝트의 특성에 맞게 조정하시기 바랍니다.


