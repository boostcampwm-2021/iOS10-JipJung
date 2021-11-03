<img width="800" alt="스크린샷 2021-11-01 오전 1 11 13" src="https://user-images.githubusercontent.com/38206212/139592483-d48d6519-27c7-4d80-8de7-8031654168a0.png">

> `JipJung`은 집중에 도움이 되는 사운드 컨텐츠를 제공하는 서비스 입니다.
> 
> 크게 2가지 컨텐츠 모드가 있으며 사운드와 함께 시각적인 애니메이션을 즐길 수 있습니다.
> 
> 기본적인 디자인은 [Tide](https://apps.apple.com/kr/app/tide-sleep-focus-meditation/id1077776989) 앱을 참고하였습니다.

## 👨🏻‍💻 팀원 소개

|  iOS |  iOS |  iOS |  iOS |  
| :------------: | :------------: | :------------: | :------------: |
|  <img width=240 src=https://media.giphy.com/media/szf5P2VvfOeShdnhOc/giphy.gif>  | <img width=240 src=https://user-images.githubusercontent.com/40790219/139001161-87c697a8-bb79-4feb-b0ef-514f3af25a82.jpeg> | <img width=240 src=https://user-images.githubusercontent.com/68768628/138987287-3f3afb65-2219-4e7f-a66d-62facb620776.gif>  | <img width=240 src=https://user-images.githubusercontent.com/38206212/139246077-5e48b153-3a0a-414a-ae6c-2bd4b76cde22.gif>  |
|  `S031` [오현식🎧](https://github.com/Kinaan-Oh)  |  `S034` [윤상진💿](https://github.com/alibreo3754)  |  `S039` [이수현📢](https://github.com/soohyeon0487)  |  `S055` [조기완🔊](https://github.com/jogiking)


저희 팀의 일하는 방식이 담긴 [팀 위키](https://github.com/boostcampwm-2021/iOS10-JipJung/wiki)입니다.

## ✨ 서비스 소개

#### 휴식/스트레스 해소를 위한 2가지 모드의 사운드 컨텐츠

#### 집중을 돕는 타이머
- 여러가지 모드의 타이머를 제공(4가지)

#### 감성적인 UI/UX
- 각종 애니메이션으로 집중할 수 있는 화면을 제공

## 🛫 기술적 도전
1. Apple 기본 제공 프레임워크를 이용한 커스텀 애니메이션
2. AVFoundation을 이용한 미디어 처리
3. 미디어 파일을 다운로드하고 관리하기 위한 로컬 캐싱
4. CI/CD 적용

## 🔨 기술 스택

[![platform](https://img.shields.io/badge/Platform-iOS-black)]() [![Swift](https://img.shields.io/badge/Swift-5.5-orange)]() [![Xcode](https://img.shields.io/badge/Xcode-13.0-orange)]() 
[![Firebase](https://img.shields.io/badge/Firebase-8.9.0-red)]() [![Realm](https://img.shields.io/badge/Realm-10.18.0-red)]()
[![RxSwift](https://img.shields.io/badge/RxSwift-6.2.0-green)]() [![Snapkit](https://img.shields.io/badge/Snapkit-5.0.1-blue)]()

## 🧮 협업 도구
- Github (Wiki, Project)
- Slack
  | 메시지, Github과 연동 | 
  | :------------: |
  | <img height="300" src="https://i.imgur.com/d1e6bC1.png"> |
- Zoom (회의)
- HackMD (공동편집)
- Xd & Figma (컨텐츠 분석 및 생산)


## 🏗 아키텍쳐 및 폴더 구조

iOS 클린 아키텍쳐 구조를 기본적으로 채용하였고 프레젠테이션 계층에 MVVM 패턴을 적용하였습니다.<br>
클린아키텍쳐의 레이어 단위로 디렉토리 구조를 나누었습니다.

![](https://i.imgur.com/mOCP7Ow.png)

### 디렉토리 구조
```bash
JipJung
│
├── Application
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── Asset
├── UI
│   ├── Common
│   ├── Home
|   │   ├── Main
|   │   ├── Categories
|   │   ├── Focus
|   │   └── Maxim
│   ├── Explore
|   │   ├── Main
|   │   └── Search
│   ├── Me
|   │   ├── Main
|   │   ├── FavoriteMaxim
|   │   └── FavoriteSound
│   └── Sound
├── Domain
│   ├── Entities
│   ├── Interfaces
│   └── Usecases
├── Data
│   ├── Interfaces
│   └── Repositories
├── Infra
│   ├── File
│   ├── LocalDB
│   ├── Network
│   └── UserDefaults
├── Info.plist
└── GoogleService.json
``` 

#### 참고자료
- [iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- [원문](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)
