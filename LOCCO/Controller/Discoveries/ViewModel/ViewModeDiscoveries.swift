//
//  ViewModeDiscoveries.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 21/02/24.
//

import UIKit

class ViewModelDiscoveries{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    var arrayCardPlayData:[CardPlayModel] = []
    init(){
        createSectionData()
    }
    fileprivate func createCardPlayData(){
        arrayCardPlayData.removeAll()
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture1"), titleLbl: "Edith Bogan", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture2"), titleLbl: "Clark Becker", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture3"), titleLbl: "Michael Collier", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture4"), titleLbl: "Francis Breitenberg", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture5"), titleLbl: "Joel Prosacco", subTitleLbl:"Restaurant"))
    }
    fileprivate func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        arraySectionData.append(SectionModel(identifier: "HederInfo",rows: [
            Rowmodel(title: "HederInfo", Identifier: "HederInfo",type: "HederInfo")
        ]))
            createCardPlayData()
            // Create the first section with the first three items from arrayCardPlayData
            let firstThreeItems = Array(arrayCardPlayData.prefix(3))
            let firstSectionRows: [Rowmodel] = firstThreeItems.map { cardPlayModel in
                return Rowmodel(title: cardPlayModel.titleLbl, Identifier: "Discoveries", subtitle: cardPlayModel.subTitleLbl, icon: cardPlayModel.image, type: "Discoveries")
            }
            arraySectionData.append(SectionModel(identifier: "FirstSection", rows: firstSectionRows))

            // Create the second section with the remaining items from arrayCardPlayData
            let remainingItems = Array(arrayCardPlayData.dropFirst(3))
            let secondSectionRows: [Rowmodel] = remainingItems.map { cardPlayModel in
                return Rowmodel(title: cardPlayModel.titleLbl, Identifier: "Discoveries", subtitle: cardPlayModel.subTitleLbl, icon: cardPlayModel.image, type: "Discoveries")
            }
            arraySectionData.append(SectionModel(identifier: "SecondSection", rows: secondSectionRows))
        }
}



