# Anabada(아나바다)

## Project Description

### Skills Used
- Python
- Flutter
- Gemini
- Firebase

### Data Analysis
#### 데이터 분석 및 Anabada 앱 개발

이 프로젝트에서는 지구온난화 문제 해결을 목표로 다양한 데이터를 분석하고, 그 결과를 바탕으로 재활용 촉진 앱인 Anabada를 개발했습니다. 주요 분석 내용 및 결과는 다음과 같습니다:

- **OECD 국가별 CO2 배출량 및 쓰레기 처리 비율 분석**
- **온실가스 배출량과 지표면 온도 상승 간의 상관관계 분석**
- **머신러닝 모델(Linear Mixed Effects Model, LGBM, Random Forest) 적용을 통한 온실가스의 영향 분석**

Anabada 앱은 이러한 분석 결과를 바탕으로, 재활용을 촉진하고 사용자들이 환경 보호에 적극 참여할 수 있도록 설계되었습니다.

**코드, 발표자료, 보고서**는 모두 **Analysis 폴더**에 있습니다.


### Anabada Project Description
환경오염이 심해짐에 따라 탄소 배출량을 감소시키기 위한 어플 제작 프로젝트입니다. 쓰레기의 재활용률이 가장 낮은 미국을 대상으로 하였으며, Gemini API를 이용하여 재활용 쓰레기을 인식하게 하고 쓰레기 버리는 과정을 인증하게 만듦으로써 포인트를 부여하고, 포인트를 통해 스타벅스, 아마존, 월마트 기프트 카드를 구매할 수 있도록 설정하였습니다.


### Anabada Project Structure

| **디렉토리/파일**              | **설명**                                                                                      |
|---------------------------------|----------------------------------------------------------------------------------------------|
| 📦 **anabada**                  |                                                                                              |
| lib                          | 메인 라이브러리 폴더                                                                           |
|account                   |                                                                                              |
|account.dart           | 유저 계정 정보를 표시하고 수정하는 기능                                                         |
|login                     |                                                                                              |
| find_email.dart        | 이메일을 잃어버렸을 때 이메일을 찾는 기능                                                      |
| find_password.dart     | 비밀번호를 잃어버렸을 때 비밀번호를 찾는 기능                                                 |
| login.dart             | 로그인 기능을 처리                                                                             |
| register.dart          | 회원 가입 기능을 처리                                                                          |
| recycle                   |                                                                                              |
| check_recycling_screen.dart | 재활용 가능한지 확인하는 기능                                                            |
| get_point_screen.dart  | 포인트를 얻는 기능                                                                            |
| recycling_screen1.dart | 포인트 획득 기능에서 재활용 가능한지 확인하는 기능                                           |
| recycling_screen2.dart | 재활용 인증샷을 찍는 화면 기능                                                               |
| taking_out_screen.dart | 인증샷을 찍고 Gemini API가 재활용 여부를 판단하는 기능                                        |
| setting                   |                                                                                              |
| QNAScreen.dart         | 앱 관련 Q&A 기능                                                                              |
| edit.dart              | 닉네임과 비밀번호를 변경하는 기능                                                              |
| font_size_provider.dart| 폰트 크기를 변경하는 기능                                                                     |
| image_provider.dart    | 앱에 카메라 및 이미지 접근 권한을 부여하는 기능                                               |
| reward_history.dart    | 포인트로 구매한 보상 내역을 보여주는 기능                                                      |
| setting_options.dart   | 파운드를 그램으로 변환하는 기능 및 나중에 추가할 설정을 위한 파일                             |
| settings.dart          | 유저별 설정을 관리하는 기능                                                                    |
| theme_notifier.dart    | 다크모드와 라이트모드 설정 기능                                                               |
| firebase_options.dart        | Firebase 관련 옵션을 설정하는 기능                                                            |
| home.dart                    | 회원가입 또는 로그인 후 홈 페이지를 보여주는 기능                                             |
| information.dart             | 재활용 관련 정보를 제공하는 기능                                                              |
| main.dart                    | 앱 실행, 탭 간 이동, 로그인, 로그아웃 등 앱의 주요 기능을 총괄하는 기능                        |
| points.dart                  | 유저별 누적 포인트와 쓰레기 배출량을 보여주는 기능                                            |
| recycle.dart                 | Gemini API를 이용해 재활용 인증을 하고 포인트를 제공하는 어플의 메인 기능                      |
| reward.dart                  | 포인트로 구매할 수 있는 보상을 보여주는 기능                                                  |
