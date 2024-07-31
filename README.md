# Anabada

# 프로젝트 설명
환경오염이 심해짐에 따라 탄소 배출량을 감소시키기 위한 어플 제작 프로젝트입니다. 쓰레기의 재활용률이 가장 낮은 미국을 대상으로 하였으며, Gemini API를 이용하여 재활용 쓰레기을 인식하게 하고 쓰레기 버리는 과정을 인증하게 만듦으로써 포인트를 부여하고, 포인트를 통해 스타벅스, 아마존, 월마트 기프트 카드를 구매할 수 있도록 설정하였습니다.

# Skills Used
- Flutter
- Gemini
- Firebase

# Project Structure


```
📦 anabada
├─ lib
│  ├─ account.dart #유저 계정과 관련한 정보를 표시, 변경 기능
│  ├─ login
│  │  ├─ find_email.dart #email을 잃어버렸을 때 email을 찾는 기능
│  │  ├─ find_password.dart #password를 잃어버렸을 때 password를 찾는 기능
│  │  ├─ login.dart #login 관련 기능
│  │  └─ register.dart #회원 가입 관련 기능
│  └─ setting
│     ├─ edit.dart #닉네임, 비밀번호 변경하는 기능
│     ├─ font_size_provider.dart #font size를 변경 기능
│     ├─ image_provider.dart #어플 카메라 권한, 이미지 가져오는 권한을 부여 기능 
│     ├─ reward_history.dart #포인트를 통해 구매한 Reward History를 보여주는 기능
│     ├─ setting_options.dart #파운드를 그램으로 만드는 기능 + 나중에 세팅을 추가할 때 쓰려고 만든 dart 파일
│     └─ settings.dart #유저 별로 세팅을 총괄하는 기능
├─ firebase_options.dart #firebase 관련된 options를 설정하는 기능
├─ home.dart #회원가입 혹은 로그인 후 어플을 실행하면 나오는 홈 페이지를 보여주는 기능
├─ information.dart #재활용 관련 정보를 보여주는 기능
├─ main.dart #어플 실행, 탭 간 이동, 로그인, 로그아웃 기능 등을 총괄하는 어플 메인 기능
├─ points.dart #유저 별로 누적 포인트, 유저 별 쓰레기 버린 양 등을 보여주는 기능
├─ recycle.dart #어플의 메인 기능. Gemini를 이용해 재활용 쓰레기 입증,인증 기능과 인증 시 포인트를 제공하는 기능
└─ reward.dart #포인트를 통해 어떤 Reward를 구매할 수 있는 지를 보여주는 기능
```

