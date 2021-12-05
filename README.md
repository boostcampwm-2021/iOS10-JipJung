# 🚀 프로젝트 소개

<img src=https://i.imgur.com/1OFFcvI.png width=800>

>🎧 JipJung은 집중에 도움이 되는 사운드 콘텐츠를 제공하는 서비스입니다.
>
>크게 2가지 콘텐츠 모드가 있으며 사운드와 함께 시각적인 애니메이션을 즐길 수 있습니다.
>
>기본적인 디자인과 기능은 [Tide](https://tide.fm/en_US/) 앱을 참고하였습니다.

### 🛀 집중과 휴식은 반대가 아닙니다.

> 일에 몰두하는 것도 집중, 오롯이 휴식만을 즐기는 것도 집중입니다.

### 🧘 휴식에도 종류가 있지 않을까요?

> 편안한 소리로 긴장을 푸는 것도 휴식이지만, 신나는 음악으로 스트레스를 해소하는 것도 휴식일 거예요!

### 🎧 직접 녹음한 음원들을 들으며 현장감을 느껴보세요!

> 각 음원별 주제와 콘셉트에 맞추어 고품질 마이크로 실제 녹음한 음원을 제공합니다.

### ✒️ 가끔은 위로의 한 마디, 응원의 한 마디가 필요하지 않으신가요?

> 하루 한 줄, 당신의 마음을 편안하게 해 줄 글을 소개해드릴게요.

## 💡 주요 기능

| 홈화면 상단 | 홈화면 하단 | 오늘의 명언 | 집중 통계 화면 |
|:--------:|:--------:|:--------:|:--------:|
| <img src=https://i.imgur.com/aTXkKx2.gif width=200> | <img src=https://i.imgur.com/6slXjyG.gif width=200> | <img src=https://i.imgur.com/2252pmp.gif width=200> | <img src=https://i.imgur.com/ZgZxgwm.gif width=200> |


| 기본 타이머 | 뽀모도로 타이머 | 무한 타이머 | 숨쉬기 타이머 |
|:--------:|:--------:|:--------:|:--------:|
| <img src=https://i.imgur.com/d2Gmixj.gif width=200>|<img src=https://i.imgur.com/A3zOlOf.gif width=200>|<img src=https://i.imgur.com/SAJ8VKk.gif width=200>|<img src=https://i.imgur.com/7Qz5wMs.gif width=200>|


| 태그 선택 기능 | 검색 기능 | 음원 재생 | Bright 모드 | Dark 모드 |
|:--------:|:--------:|:--------:|:--------:|:--------:|
|<img src=https://i.imgur.com/d85izQi.gif width=200>|<img src=https://i.imgur.com/hOSEY4U.gif width=200>|<img src=https://i.imgur.com/KnWTjAF.gif width=200>|<img src=https://i.imgur.com/rBnrEsj.gif width=200>|<img src=https://i.imgur.com/YGPzOMv.gif width=200>|

## 🏛 프로젝트 구조
### MVVM 기반 **Clean Architecture**
iOS 클린 아키텍쳐 구조를 기본적으로 채용하였고 프레젠테이션 계층에 MVVM 패턴을 적용하였습니다.

클린아키텍쳐의 레이어 단위로 디렉토리 구조를 나누었습니다.
<img src=https://i.imgur.com/hjX2XLK.png width=800>

## 🛠 사용한 프레임워크

### 🍎 Apple First-party Library

#### AVKit

- 음원과 동영상의 반복 재생을 위해 사용했습니다.

#### CoreAnimation

- 집중모드 기능에서 사용할 애니메이션을 위해 사용했습니다.
- Pulse, 혜성, 비정형 도형, Text 애니메이션을 구현했습니다.
- 애니메이션 목적 외에도 UI 개선을 위해 사용했습니다

#### SpriteKit

- 클럽 분위기를 연출하기 위해 빛을 다루기에 적합한 SpriteKit을 채택하였습니다.
- SKLightNode, SKSpriteNode, SKAction을 이용하여 해당 애니매이션을 구현하였습니다.

### 🔧 Third-party Library

#### Firebase/Storage

- 음원 다운로드 기능을 구현하기 위해 사용하였습니다.
- 백엔드 서버에 많은 투자를 하지 않고 쉽게 구현할 수 있다는 점이 매력적이였습니다.

#### RxSwift

- ViewModel과 View의 Data Bind와 비동기 로직을 담당하기 위해 추가하였습니다.
- Callback이나 NotificationCenter등으로도 관리할 수 있지만, Callback은 Callback Hell과 가독성 문제가 있고 NotificationCenter는 어디서 변경될 지 모르고 사용하는 측에서도 Key와 타입을 직접 관리해야하는 등의 문제가 있습니다.
- Apple의 FirstParty인 Combine은 출시된지 얼마되지 않아 최소타겟 문제가 있고 참고할 예제가 더 많은 RxSwift를 채택하였습니다.

#### RealmSwift

- 선호목록, 타이머 이용기록 등의 정보들을 저장하기 위해서 사용하였습니다.
- Apple의 FirstParty Framework인 CoreData에 비해 속도가 빠르고, 코드량도 줄어 개발 생산성에 더 좋다고 판단하여 도입하게 되었습니다.

#### SnapKit

- 코드로만 뷰를 작성하기 때문에 오토레이아웃 설정을 좀 더 간편하게 하기위해 도입했습니다.

#### SwiftLint

- 협업시 코딩스타일에 대한 기본적인 룰을 정하고 지키기 위해서 사용하였습니다.
- 코드 리뷰 때 체크해야할 컨벤션 오류에 대한 확인을 컴퓨터에게 위임할 수 있었습니다.

## 기술 특장점

### UserInteraction

#### 🤗 사용자 경험 향상을 위한 애니메이션

- 자연스럽게 앱에 빠져들 수 있도록 부드러운 화면전환에 신경 썼습니다.
- 타이머 각각의 특징을 보여줄 수 있는 애니메이션을 제공해서 사용자가 직관적으로 어떤 타이머인지 알 수 있도록 만들었습니다.
- SpriteKit을 이용하여 다크모드의 클럽 조명 애니메이션을 구현하였습니다.

#### 🍕 재사용성을 위한 애니메이션 기능

- UIViewAnimate, CAAnimation 등을 적절하게 사용해서 커스텀 애니메이션을 구현하였습니다.
- 커스텀 애니메이션은 필요한 곳에서 사용할 수 있도록 의존성을 분리하여 제작하였습니다.

#### ♻️ 동영상이 포함된 무한 스크롤을 위한 커스텀 뷰

- 끊임없이 이어지는 느낌을 주기 위해 직접 구현한 커스텀 뷰를 사용하였습니다.
- 좌우 스크롤하면 다음 화면의 비디오/오디오를 부드럽게 자동 재생합니다.

### UI based Code (w/o storyboard)

#### 🧑‍💻 Storyboard를 사용하지 않은 이유

- 각자가 다른 기능을 맡아서 작업을 처리하는 `분업`이 아닌 여러 사람이 공통의 문제를 해결하는 `협업`을 하다보면 스토리보드로 작업했을 때 작업 충돌이 많이 생길 거라 예측하였고 코드로 작업하기 위해 노력했습니다.
- 코드로 작업을 하다보니 git을 통해 서로의 코드를 쉽게 리뷰해줄 수 있었고 통일성 있는 코드를 작성할 수 있었습니다.

#### 🧑‍💻 코드를 줄이기 위해 했던 노력들

- 재사용성을 높이기 위해 공통 UI 컴포넌트(Button, CardView 등)을 만들었습니다.
- Autolayout을 쉽게 작성하고 코드를 줄이기 위해 이미 많이 사용되고 있는 Snapkit 라이브러리를 활용하였습니다.
- Extension과 Generic을 적절히 활용해서 반복되는 코드를 줄이기 위해 노력했습니다.
    
    ```swift
    // EX)
    extension UICollectionViewCell {
        static var identifier: String {
            return String(describing: self)
        }
    }
    
    extension UICollectionView { 
        func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T? {
            return self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
        }
    }
    ```
    

## 🧑‍🤝‍🧑  팀원 소개

|  iOS |  iOS |  iOS |  iOS |  
| :------------: | :------------: | :------------: | :------------: |
|  <img width=240 src=https://media.giphy.com/media/szf5P2VvfOeShdnhOc/giphy.gif>  | <img width=240 src=https://user-images.githubusercontent.com/40790219/139001161-87c697a8-bb79-4feb-b0ef-514f3af25a82.jpeg> | <img width=240 src=https://user-images.githubusercontent.com/68768628/138987287-3f3afb65-2219-4e7f-a66d-62facb620776.gif>  | <img width=240 src=https://user-images.githubusercontent.com/38206212/139246077-5e48b153-3a0a-414a-ae6c-2bd4b76cde22.gif>  |
|  `S031` [오현식🎧](https://github.com/Kinaan-Oh)  |  `S034` [윤상진💿](https://github.com/alibreo3754)  |  `S039` [이수현📢](https://github.com/soohyeon0487)  |  `S055` [조기완🔊](https://github.com/jogiking)

## 👨‍💻 팀 개발 문화

팀 개발문화, 기술적인 이슈들은 [팀 위키](https://github.com/boostcampwm-2021/iOS10-JipJung/wiki)에서 확인할 수 있습니다.
