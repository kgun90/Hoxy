//
//  TagViewModel.swift
//  Hoxy
//
//  Created by Geon Kang on 2021/06/19.
//

import Foundation

struct TagViewModel{

    let tagList = Observable([TagModel]())
    let tagData = Observable([String]())
    let alert = Observable(TagAlertModel())
    
    var title = ""
    
    var dataManager = TagDataManager()
    
    var tagCount: Bool {
        return tagData.value.count > 4
    }
    
    var tagLength: Bool {
        return title.count > 10
    }
    
    func requestTagList() {
        TagDataManager.getTagData { data in
            self.tagList.value = data
        }
    }
    
    func addTag(_ title: String) {
        tagData.value.append(title)
    }
    
    func removeTag(_ title: String?) {
        if title != nil {
            tagData.value = tagData.value.filter({ $0 != title })
        }
    }
    
    func alertControl() {
        if tagLength {
            alert.value = TagAlertModel(title: "태그가 너무 길어요", message: "태그 길이는 10자 이내로 작성 바랍니다.")
            return
        }
        if tagCount {
            alert.value = TagAlertModel(title: "태그가 너무 많아요", message: "태그는 5개까지 작성 가능합니다.")
            return
        }
        addTag(title)
    }
}
