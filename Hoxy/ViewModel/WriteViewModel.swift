//
//  WriteViewModel.swift
//  Hoxy
//
//  Created by FNS-건 on 2021/05/25.
//

import Foundation
import UIKit.UIColor

struct WriteViewModel {
    var writeContents = WriteContentsModel()
    let submitButton = Observable(WriteButtonModel())
    let bindingContents = Observable(WriteContentsModel())
    
    var validContents: Bool {
        return writeContents.title.count > 5
            && writeContents.location != ""
            && writeContents.count != ""
            && writeContents.communicationLevel != ""
            && writeContents.duration != ""
            && writeContents.content.count >= 10
    }
    
    func submitButtonValidation() {
        submitButton.value.color = (validContents ? .mainYellow : #colorLiteral(red: 0.5058823529, green: 0.5058823529, blue: 0.5058823529, alpha: 1))
        submitButton.value.enable = (validContents ? true : false)
    }
}

