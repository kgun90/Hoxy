//
//  String.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/01/27.
//

import UIKit

extension String {
    
    func pretty() -> String {
        let _str = self.replacingOccurrences(of: "-", with: "") // 하이픈 모두 빼준다
        let arr = Array(_str)
        
        if arr.count > 3 {
            let prefix = String(format: "%@%@", String(arr[0]), String(arr[1]))
            if prefix == "02" { // 서울지역은 02번호
                
                if let regex = try? NSRegularExpression(pattern: "([0-9]{2})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [],
                                                                   range: NSRange(_str.startIndex..., in: _str),
                                                                   withTemplate: "$1-$2-$3")
                    return modString
                }
                
            } else if prefix == "15" || prefix == "16" || prefix == "18" { // 썩을 지능망...
                if let regex = try? NSRegularExpression(pattern: "([0-9]{4})([0-9]{4})", options: .caseInsensitive) {
                    let modString = regex.stringByReplacingMatches(in: _str, options: [],
                                                                   range: NSRange(_str.startIndex..., in: _str),
                                                                   withTemplate: "$1-$2")
                    return modString
                }
            } else { // 나머지는 휴대폰번호 (010-xxxx-xxxx, 031-xxx-xxxx, 061-xxxx-xxxx 식이라 상관무)
                    if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                        let modString = regex.stringByReplacingMatches(in: _str, options: [],
                                                                       range: NSRange(_str.startIndex..., in: _str),
                                                                       withTemplate: "$1-$2-$3")
                        return modString
                    }
                }
            
        }
        
        return self
    }
    
    // E-mail address validation
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    // Password validation
    func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$%^&*()?~_]).{8,16}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
    // Phone Number Validation
    func validatePhoneNum() -> Bool {
        let regex = "^(?=.*[0-9]).{11}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
    // Phone Number Validation
    func validateAuthCode() -> Bool {
        let regex = "^(?=.*[0-9]).{6}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
    //랜덤 이모지 생성
    func randomEmoji()->String{
          let emojiStart = 0x1F601
          let ascii = emojiStart + Int(arc4random_uniform(UInt32(100)))
          let emoji = UnicodeScalar(ascii)?.description
          return emoji ?? "😍"
      }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.BasicFont(.semiBold, size: 16)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont, boldFont: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func attributedText(withString string: String, coloredString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let colorFontAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(hex: 0x707070)]
        let range = (string as NSString).range(of: coloredString)
        attributedString.addAttributes(colorFontAttribute, range: range)
        return attributedString
    }
    
    func nicknameGenerate() -> String{
        return "\(Constants.title[Int.random(in: 0 ..< Constants.title.count)]) \(Constants.nickname[Int.random(in: 0 ..< Constants.nickname.count)])"
    }
    
    func getMeetingTime(_ start: Date, _ duration: Int) -> String{
        let startTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM.dd hh시 mm분"
        }
        let startTime = startTimeFormat.string(from: start)
        
        let endTimeFormat = DateFormatter().then {
            $0.dateFormat = "hh시 mm분"
        }
        let end = start.addingTimeInterval(TimeInterval(duration * 60))
        let endTime = endTimeFormat.string(from: end)
        let timedifference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        
        if let hour = timedifference.hour, let minute = timedifference.minute {
            return  "\(startTime)~\(endTime) \(hour)시간 \(minute)분"
        } else {
            return ""
        }
    }
    
    func getMeetingTime(_ date: Date) -> String{
        let startTimeFormat = DateFormatter().then {
            $0.dateFormat = "MM/dd hh시mm분 예정"
        }
        let startTime = startTimeFormat.string(from: date)
        
        return startTime
    }
}
 

