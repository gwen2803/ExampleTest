# ExampleTest
Example for UnitTest, UITest, Quick, Nimble



# ExampleForTest

## 프로젝트 소개

`ExampleForTest`는 XCTest, Quick, Nimble 등 다양한 Swift 테스트 프레임워크를 학습하고 비교하기 위해 만들어진 iOS 프로젝트입니다. SwiftUI를 사용하여 간단한 기능들을 구현하고, 각 기능에 대한 유닛 테스트를 작성하여 테스트 방법론과 커버리지를 탐구합니다.

## 주요 기능

이 프로젝트는 다음 세 가지 주요 기능을 포함합니다.

1.  **사용자 등록 유효성 검사기 (User Registration Validator)**
    *   사용자 이름, 이메일, 비밀번호 입력 필드
    *   Combine을 활용한 실시간 유효성 검사 및 피드백
    *   백그라운드 스레드에서 실행되는 최적화된 유효성 검사 로직
    *   모든 필드 유효 시 등록 성공 알림

2.  **쇼핑 카트 계산기 (Shopping Cart Calculator)**
    *   상품 추가 및 삭제 기능
    *   장바구니 내 상품 총액 실시간 계산
    *   새 상품 추가 시 리스트 자동 스크롤
    *   MVVM 원칙에 따른 가격 포맷팅 로직 분리

3.  **간단한 환율 계산기 (Simple Currency Converter)**
    *   금액 및 통화 선택을 통한 환율 변환
    *   Combine을 활용한 실시간 변환 계산
    *   백그라운드 스레드에서 실행되는 최적화된 변환 로직

## 시작하기

이 프로젝트를 로컬 환경에서 실행하기 위한 설정 방법입니다.

### 전제 조건

*   Xcode (최신 버전 권장)

### 의존성 설치

1.  프로젝트 저장소를 클론합니다.
git clone [프로젝트 저장소 URL]
cd ExampleForTest

2.  Xcode에서 프로젝트를 연 후, Swift Package Manager 의존성을 자동으로 해결합니다. (별도의 `pod install` 등의 명령어는 필요하지 않습니다.)

### 프로젝트 열기

*   `ExampleForTest.xcodeproj` 파일을 열어서 작업합니다.

## 테스트 실행

이 프로젝트는 XCTest와 Quick/Nimble 두 가지 방식으로 테스트 코드를 작성하여 비교 학습할 수 있도록 구성되어 있습니다.

1.  `ExampleForTest.xcodeproj` 파일을 Xcode에서 엽니다.
2.  Xcode 메뉴 바에서 **Product > Test** (`Cmd+U`)를 선택하거나, 테스트 네비게이터(다이아몬드 아이콘)에서 원하는 테스트를 실행합니다.

## 프로젝트 구조
```
  ExampleForTest/
  ├── ExampleForTestApp.swift   # 앱 진입점
  ├── MainView.swift            # 메인 기능 선택 화면
  ├── Features/                 # 각 기능별 모듈
  │   ├── UserRegistration/
  │   │   ├── UserRegistrationView.swift
  │   │   └── UserRegistrationViewModel.swift
  │   ├── ShoppingCart/
  │   │   ├── CartItem.swift
  │   │   ├── ShoppingCartView.swift
  │   │   └── ShoppingCartViewModel.swift
  │   └── CurrencyConverter/
  │       ├── Currency.swift
  │       ├── CurrencyConverterView.swift
  │       └── CurrencyConverterViewModel.swift
  ├── Package.swift             # Swift Package Manager 패키지 정의 (선택 사항, 프로젝트가 패키지인 경우)
  └── ExampleForTestTests/      # 유닛 테스트 번들
      └── Features/
          └── UserRegistration/
              ├── UserRegistrationViewModelTests.swift      # XCTest 기반 테스트
              └── UserRegistrationViewModelQuickTests.swift # Quick/Nimble 기반 테스트
```

## 사용된 기술

*   SwiftUI
*   Combine
*   XCTest
*   Quick
*   Nimble
*   Swift Package Manager
