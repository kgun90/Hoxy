
# HOXY

익명 만남 플랫폼

- 진행기간 : 2021. 01. 18 ~ 2021. 02. 21

## 서비스 소개
<img src="https://user-images.githubusercontent.com/30033658/111910515-08fd7f80-8aa5-11eb-9a49-9b04f93bc30d.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111910531-1ca8e600-8aa5-11eb-8719-5599e9f98192.png" width="40%">

- HOXY는 사람이 필요한 사람들을 위해 모임을 개설하고 주변 사람들을 쉽게 모을 수 있도록 도와주는 Flutter/iOS 기반의 플랫폼 앱 입니다.
- 사용자의 위치정보를 통해 주변에서 개설된 모임 목록을 확인하고 이에 참여하거나 직접 모임을 개설합니다.
- 모임 개설/참여 시 생성되는 랜덤 닉네임과 이모지를 통해 익명모임을 진행합니다.
- 세가지 소통레벨(조용히 만나기, 대화 가능, 활발한 소통)로 모임을 나눠 혼밥, 액티비티 등 한사람 혹은 여러 사람이 필요한 다양한 경우의 모임을 주최할 수 있습니다.
- 채팅기능을 통해 참여자들이 실시간으로 소통하고 모임을 진행할 수 있습니다.
- 모임 이후 서로에 대한 평가 혹은 차단을 통한 이후 만남 거부 가능(예정)

## 상세 기능 소개

### 1. 회원가입

### 1-1. 회원가입
<img src="https://user-images.githubusercontent.com/30033658/111910586-50840b80-8aa5-11eb-9bd2-354abec1563c.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111910584-4f52de80-8aa5-11eb-88a5-6eb6f87f092f.png" width="40%">

- 로그인 화면에서 **회원가입** 선택시 해당 화면으로 이동하며, 현재 이메일 회원가입/로그인 기능 지원 (구글, 애플 로그인은 추후 예정)
- 이메일로 회원가입 시 휴대폰 인증을 통해 중복 가입을 방지합니다.
- 기본정보 입력 후 **진행하기** 버튼을 선택시 나오는 **정보설정** 화면에는 GPS 기반 사용자 위치를 받아 동네이름을 표시하고 이에 맞는 모임 목록을 불러옵니다, **사용연령 설정**은 모임 개설시 표시되는 정보로 타 사용자에게 제공되는 유일한 사용자 정보 입니다.

### 1-2. 로그인
<img src="https://user-images.githubusercontent.com/30033658/111910704-cdaf8080-8aa5-11eb-928f-dbe253a4b092.png" width="40%">

- 이메일로 로그인은 Firebase Authentication을 사용합니다.

### 2. 모임 개설
<img src="https://user-images.githubusercontent.com/30033658/111910725-e61f9b00-8aa5-11eb-83de-2e4431ca7876.png" width="40%">

- 인원 모집 글을 게시하고 사람을 모집하거나 모집중인 모임에 참여할 수 있습니다.
- 현재 위치 또는 프로필 위치를 기준으로 5km 근방의 모집 글이 표시됩니다.
- 만나지 않기로 설정된 회원의 게시글이나 나를 만나지 않기로 설정한 회원의 게시글은 표시되지 않습니다.

### 2-1. 모집글 게시
<img src="https://user-images.githubusercontent.com/30033658/111912347-88428180-8aac-11eb-82f7-e15408f9ba08.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111912345-8678be00-8aac-11eb-91f2-467af6cf5af6.png" width="40%">

- 인원 모집 글을 게시할 수 있습니다.
- 현재 위치와 프로필 위치 중 어느 위치에 등록할 지 선택할 수 있습니다.
- 모집 인원, 소통레벨, 시작시간, 모임시간을 정하고 글을 게시합니다.
- 닉네임은 랜덤으로 생성됩니다.

### 2-2. 모집글 조회
<img src="https://user-images.githubusercontent.com/30033658/111910742-f768a780-8aa5-11eb-9933-402d431a69bf.png" width="33%"> <img src="https://user-images.githubusercontent.com/30033658/111910741-f6377a80-8aa5-11eb-9c20-a743ced6b55d.png" width="33%"> <img src="https://user-images.githubusercontent.com/30033658/111910738-f33c8a00-8aa5-11eb-9af7-57cdf0e9db88.png" width="33%">

- 모임 글 목록에서 글을 선택하면 모임의 내용이 표시됩니다.
- 본인의 글일 경우 상단바 우측 버튼을 통해  수정, 삭제가 가능합니다.
- 다른 사람의 글일 경우 불량 모임의 신고가 가능하며, 주최자와 만나지 않기를 선택해 해당 사용자와 서로의 글을 목록에서 숨길 수 있습니다.

### 2-3. 모임 참여
<img src="https://user-images.githubusercontent.com/30033658/111912087-6eed0580-8aab-11eb-8718-ec3af8bc9d76.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111912083-6b597e80-8aab-11eb-9839-05160b4f9a64.png" width="40%">

- 모집글의 하단 **신청하기** 버튼을 눌러 모임 참여가 가능합니다.
- 상단에 표시된 인원 만큼 신청 가능하며 인원충족시 모임신청이 불가합니다.
- 팝업에 모임에서 쓰일 닉네임이 랜덤으로 생성되어 표시되고, 취소 및 신청하기를 다시 선택 시 새로 생성된 닉네임을 사용 가능 합니다.
- 이미 신청된 모임이거나 인원이 모두 찬 모임에서는 신청하기 버튼이 비활성화 되며 참여할 수 없게 됩니다.

### 3. 채팅
<img src="https://user-images.githubusercontent.com/30033658/111912111-8926e380-8aab-11eb-9422-f992130aa750.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111912107-86c48980-8aab-11eb-8a03-5adb83c59776.png" width="40%">

- 하단 Tabbar 채팅 아이콘 선택시 사용자가 참가 신청한 모임의 채팅목록이 표시되고, 선택시 Firestore를 기반으로 구현된 채팅방으로 이동합니다.
- Constraints 수정중

### 3-1. 채팅
<img src="https://user-images.githubusercontent.com/30033658/111912130-a360c180-8aab-11eb-83e8-70007ec3b23b.png" width="40%">

- 모임 개설시 자동으로 생성되는 채팅방에서 모임 참가자들과 채팅을 진행할 수 있습니다.
- 상대 프로필 이모지를 누르거나 우측 드로어 메뉴에서 상대방 프로필을 확인할 수 있습니다.
- 드로어/사이드 메뉴는 모임장/본인/나머지 참여 인원 순서로 표시되며 본인이 모임장일 경우 하나로만 표시됩니다.

### 3-2. 상대 프로필
<img src="https://user-images.githubusercontent.com/30033658/111912172-cee3ac00-8aab-11eb-94f6-e046abc96610.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111912169-cd19e880-8aab-11eb-8fd3-bce0d90109aa.png" width="40%">

- 기본적인 상대방 정보 확인과 상대방 차단이 가능합니다.

### 4. 마이페이지

- 본인의 프로필 이모지, 위치 등 정보를 관리할 수 있습니다.

### 4-1. 이모지 변경
<img src="https://user-images.githubusercontent.com/30033658/111912261-300b7f80-8aac-11eb-833b-5d16fb18e86a.png" width="40%" ><img src="https://user-images.githubusercontent.com/30033658/111912254-2d108f00-8aac-11eb-97b2-6e22921dc41e.png" width="40%">

- 자신의 프로필 이모지를 변경할 수 있습니다.
- 이모지는 랜덤으로 선택되며 원하는 이모지가 아닐 경우 재시도 버튼을 통해 다시 랜덤 이모지를 생성할 수 있습니다.
- 원하는 이모지가 나오지 않을 경우 취소 버튼을 눌러 기존의 이모지로 되돌아갈 수 있습니다.

### 4-2. 위치 변경
<img src="https://user-images.githubusercontent.com/30033658/111912287-4285b900-8aac-11eb-91d3-879775715dfc.png" width="40%"> <img src="https://user-images.githubusercontent.com/30033658/111912284-40235f00-8aac-11eb-88b2-2cb42540a5ed.png" width="40%">

- 현재 위치를 재설정하거나 프로필 위치를 현재 위치로 변경할 수 있습니다.
- 위치 요청 시 위치 권한을 확인하고 현재 위치를 가져옵니다.

### 4-3. 차단 회원 목록

- 차단한 회원의 목록을 열람하고, 차단을 해제할 수 있습니다.
- 차단을 해제하면 차단한 상대와 나에게 모두 서로의 글이 다시 보이게 됩니다.

## 보완 사항

- 구글/애플로그인 추가
- 모임에 대한 평가와 참가자 간 상호 리뷰 기능 추가예정
