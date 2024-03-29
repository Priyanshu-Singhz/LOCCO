//
//  HeaderTableViewCell.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 15/02/24.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    //MARK: -  Outlet's
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet var pathFinderLbl: UILabel!
    //MARK: - Properties
    var arrCatgroyModel:[CategoryModel] = []
    fileprivate var vmHomeScreenList = ViewModelHomeScreenList()
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        arrCatgroyModel = vmHomeScreenList.arrayCategoryData
        pathFinderLbl.text = "Pathfinder".translated
    }

}
//MARK: -  Table View Delegate's
extension HeaderTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCatgroyModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widToSet = (collectionView.bounds.width/4) - 8
        return CGSize(width: widToSet, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.setUpUI(arrCatgroyModel[indexPath.row])
        return cell
    }
}
