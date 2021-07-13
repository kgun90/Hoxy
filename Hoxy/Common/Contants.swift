//
//  Contants.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/25.
//

import UIKit
import Firebase

struct Constants {
    
    static let fs = Firestore.firestore()

    static let MEMBER_COLLECTION = Firestore.firestore().collection(Table.member)
    static let CHAT_COLLECTION = Firestore.firestore().collection(Table.chatting)
    static let POST_COLLECTION = Firestore.firestore().collection(Table.post)
    static let REPORT_COLLECTION = Firestore.firestore().collection(Table.report)
    static let TAG_COLLECTION = Firestore.firestore().collection(Table.tag)
    static let ALERT_COLLECTION = Firestore.firestore().collection(Table.alert)
    
    static let currentLocation = "current_location"
    static let currentTown = "current_town"
    static let userLocation = "user_location"
    static let userTown = "user_Town"
    
    struct Table {
        static let member = "member"
        static let chatting = "chatting"
        static let post = "post"
        static let report = "report"
        static let tag = "tag"
        static let alert = "alert"
    }
    
    static let communicationEmoji = [["😷", "🤫", "🤐"], ["😀", "😃", "😄"], ["😆", "🤩", "🥳"]]
    static let meetingLocationDemo = ["삼성동", "풍덕천동"]
    static let communicationLevel = ["조용히 만나요", "대화는 해요", "재밌게 놀아요"]
    static let headCount = [2, 3, 4]
    static let meetingDuration = ["30분", "1시간", "1시간 30분", "2시간", "2시간 30분", "3시간", "3시간 30분", "4시간"]
    static let meetingDurationDic = [30 : "30분", 60 : "1시간", 90 : "1시간 30분", 120 : "2시간", 150 : "2시간 30분", 180: "3시간", 210: "3시간 30분", 240: "4시간"]
    static let communicationDic = [1: "조용히 만나요", 2: "대화는 해요", 3: "재밌게 놀아요"]
    
    static let title = [
        "하얀",
        "파란",
        "북치는",
        "화난",
        "분노하는",
        "우울한",
        "자랑스러운",
        "끼부리는",
        "애교쟁이",
        "공부하는",
        "치킨먹는",
        "노래하는",
        "기도하는",
        "신성한",
        "길 잃은",
        "신이 난",
        "붉은",
        "검은",
        "아기",
        "꽃같은",
        "성난",
        "행복한",
        "건방진",
        "재주부리는",
        "춤추는",
        "빨간",
        "말하는",
        "똑똑한",
        "소리지르는",
        "창피한",
        "뻔뻔한",
        "답답한",
        "돈 많은",
        "수다쟁이",
        "노란",
        "슬픈",
        "감성에 젖은",
        "빈둥거리는",
        "부지런한",
        "게으른",
        "얼어붙은",
        "뜨거운",
        "정열적인",
        "성스러운",
        "건강한",
        "병약한",
        "강력한",
        "슬피 우는",
        "냉정한",
        "차가운",
        "식어버린"
    ]
    
    static let nickname = [
        "토끼",
        "코끼리",
        "여우",
        "사자",
        "거북이",
        "자라",
        "강아지",
        "고양이",
        "오랑우탄",
        "원숭이",
        "오리",
        "거위",
        "문어",
        "오징어",
        "용가리",
        "하이에나",
        "곰",
        "북극곰",
        "돼지",
        "새우",
        "사슴",
        "산삼",
        "요정",
        "펭귄",
        "악마",
        "고릴라",
        "타조",
        "고구마",
        "호박",
        "천사",
        "감자",
        "듀공",
        "인어",
        "물범",
        "쥐",
        "햄스터",
        "판다",
        "코알라",
        "호랑이",
        "사자",
        "독수리",
        "소",
        "말",
        "개구리",
        "망아지",
        "박쥐",
        "부엉이",
        "거미",
        "도롱뇽",
        "카멜레온",
        "이구아나",
        "사마귀",
        "메뚜기",
        "잠자리",
        "문어",
        "돌고래",
        "고래",
        "여치",
        "앵무새"
    ]
   
    
}
