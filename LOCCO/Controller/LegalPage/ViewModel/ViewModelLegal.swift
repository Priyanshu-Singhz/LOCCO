//
//  ViewModelLegal.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 28/02/24.
//

import UIKit

class ViewModelLegal{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    init(){
        createSectionData()
    }
    fileprivate func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        arraySectionData.append(SectionModel(identifier: "Licenses & Legal",rows: [
            Rowmodel(title: "home_legal-licenses", Identifier: "Licenses & Legal",placeholder: "", textFieldtext: "", type: "Licenses & Legal")
        ]))
        arraySectionData.append(SectionModel(identifier: "Sections",rows: [
            Rowmodel(title: "legal-licenses_page-licenses-link", Identifier: "Licenses", icon: UIImage(named: "Camera"), type: "Sections", isShowNextButton: true,isShowSeparatorLine: true),
            Rowmodel(title: "legal-licenses_page-data-protection-link", Identifier: "Data protection",icon: UIImage(named: "Lock"),type: "Sections", isShowNextButton: true,isShowSeparatorLine: true),
            Rowmodel(title: "legal-licenses_page-terms-and-conditions-link", Identifier: "Terms & Conditions",icon: UIImage(named: "ic_menu_book"),type: "Sections", isShowNextButton: true),
        ]))
        arraySectionData.append(SectionModel(identifier: "ContactEmail",rows: [
            Rowmodel(title: "", Identifier: "", type: "ContactEmail")
        ]))
    }
}
