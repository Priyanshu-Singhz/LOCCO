//
//  File.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import Foundation
import UIKit

struct SectionModel{
    var identifier:String = ""
    var rows:[Rowmodel] = []
}
struct Rowmodel{
    var title,Identifier:String
    var placeholder,subtitle,trailingText,textFieldtext,date,time:String?
    var icon:UIImage?
    var type:String?
    var error:String?
    var isShowNextButton:Bool = false
    var isShowSeparatorLine:Bool = false
    var isTralingText:Bool = false
}

struct CategoryModel{
    var image:UIImage?
    var Count,text:String?
}

struct CardPlayModel{
    var image:UIImage?
    var titleLbl,subTitleLbl:String
}
