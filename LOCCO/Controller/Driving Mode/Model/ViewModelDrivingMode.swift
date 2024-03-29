//
//  ViewModelDrivingMode.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 01/03/24.
//
import UIKit

class ViewModelDrivingMode{
    //MARK: - Properties
    var arraySectionData:[SectionModel] = []
    var arrayCardPlayData:[CardPlayModel] = []
    var arrayCategoryData:[CategoryModel] = []
    init(){
        createCardPlayData()
        createSectionData()
        createCategoryData()
    }
    // Create the CategoryData
    fileprivate func createCategoryData(){
        arrayCategoryData.removeAll()
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "Castle"), text: "request_audio_categories_1-sight"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "ic_mountain"), text: "request_audio_categories_1-nature"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "brown signs"), text: "request_audio_categories_1-sign"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "building"), text: "request_audio_categories_1-city"))
    }
    // Create the CategoryData
    func createCategoryData1(){
        arrayCategoryData.removeAll()
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "Chef Hat"), text: "request_audio_categories_2-restaurant"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "Tea Cup"), text: "request_audio_categories_2-cafe"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "shopping_bag"), text: "request_audio_categories_2-products"))
        arrayCategoryData.append(CategoryModel(image: UIImage(named: "hiking_man"), text: "request_audio_categories_2-activity"))
    }

    fileprivate func createCardPlayData(){
        arrayCardPlayData.removeAll()
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture6"), titleLbl: "Edith Bogan", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture7"), titleLbl: "Edith Bogan", subTitleLbl:"Restaurant"))
        arrayCardPlayData.append(CardPlayModel(image: UIImage(named: "Picture8"), titleLbl: "Edith Bogan", subTitleLbl:"Restaurant"))
    }
    fileprivate func createSectionData(){
        arraySectionData.removeAll()
        //Header Model
        let allRows: [Rowmodel] = arrayCardPlayData.map { cardPlayModel in
            return Rowmodel(title: cardPlayModel.titleLbl, Identifier: "Discoveries", subtitle: cardPlayModel.subTitleLbl, icon: cardPlayModel.image, type: "Discoveries")
        }
        arraySectionData.append(SectionModel(identifier: "Discoveries",rows:allRows))
    }
}



