//
//  ViewModelHomeScreenList.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import Foundation
import UIKit

class ViewModelHomeScreenList{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    var arrayCategoryData:[CategoryModel] = []
    //Init Method
    init(){
        createSectionData()
        createCategoryData()
    }
    
    // Create the CategoryData
    fileprivate func createCategoryData(){
        arrayCategoryData.removeAll()
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "ic_menu_startShine"), Count: "25"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "ic_menu_tunnel"), Count: "18"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "ic_menu_arrow_up"), Count: "25"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "ic_menu_PointOnMap"), Count: "3"))
    }
    
    // Create the SectionData
    fileprivate func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        arraySectionData.append(SectionModel(identifier: "Header",rows: [
            Rowmodel(title: "Header", Identifier: "Header", icon: nil, type: "Header"),
        ]))
        // Section 1
        arraySectionData.append(SectionModel(identifier: "Section1",rows: [
            Rowmodel(title: "home_discoveries", Identifier: "discoveries", icon: UIImage(named: "ic_menu_tunnel"), type: "Section",isShowSeparatorLine: true),
            Rowmodel(title: "home_routes", Identifier: "routes", icon: UIImage(named: "ic_menu_route"), type: "Section",isShowSeparatorLine: true),
            Rowmodel(title: "reminder_page_title", Identifier: "reminders", icon: UIImage(named: "ic_menu_alarm"), type: "Section"),
        ]))
        // Section 2
        arraySectionData.append(SectionModel(identifier: "Section2",rows: [
            Rowmodel(title: "home_profile", Identifier: "myProfile", icon: UIImage(named: "ic_menu_user"), type: "Section")
        ]))
        //Section 3
        arraySectionData.append(SectionModel(identifier: "Section3",rows: [
            Rowmodel(title: "home_how-it-works", Identifier: "howLoccoWorks", icon: UIImage(named: "ic_menu_book"), type: "Section",isShowSeparatorLine: true),
            Rowmodel(title: "home_FAQs", Identifier: "faq", icon: UIImage(named: "ic_menu_question"), type: "Section",isShowSeparatorLine: true),
            Rowmodel(title: "legal-licenses_page-subtitle", Identifier: "licence", icon: UIImage(named: "ic_menu_licence"), type: "Section"),
        ]))
    }
}
