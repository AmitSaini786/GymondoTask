//
//  ExerciseCVViewDataSource.swift
//  AssignmentGymondo
//
//  Created by Amit on 03/05/22.
//

import Foundation
import UIKit


class ExerciseCVViewDataSource<CELL : UICollectionViewCell,T> : NSObject, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
    var  details : ExercisDetailsViewModel?

    //Configure cell data
    init(cellIdentifier : String, items : [T] , configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    //MARK: -- UICollectionView Data source --

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if items.count > 0 && details?.excDetails.variations?.count ?? 0 > 0{
            return 2
        }else{
            if items.count > 0 && details?.excDetails.variations?.count ?? 0 == 0{
                return 1
            }
            else if items.count == 0 && details?.excDetails.variations?.count ?? 0 > 0{
                return 1
            }else{
                return 0
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && items.count>0{
            return items.count
        }
        else if section == 0 && items.count == 0 && details?.excDetails.variations?.count ?? 0 == 0{
            return 0
        }
        else if section == 0 && items.count == 0 && details?.excDetails.variations?.count ?? 0 > 0{
            return details?.excDetails.variations?.count ?? 0
        }
        else if section == 1 && details?.excDetails.variations?.count ?? 0 > 0{
            return details?.excDetails.variations?.count ?? 0
        }
        else if section == 1 && details?.excDetails.variations?.count ?? 0 == 0{
            return 0
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && self.items.count > 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName.exerciseImageCell, for: indexPath) as! CVExerciseImageCell
            cell.lblVariations.isHidden = true
            cell.imgExercise.isHidden = false
            let item = self.items[indexPath.row]
            self.configureCell(cell as! CELL, item)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName.exerciseImageCell, for: indexPath) as! CVExerciseImageCell
            cell.lblVariations.isHidden = false
            cell.imgExercise.isHidden = true
            cell.lblVariations.text = String(details?.excDetails.variations?[indexPath.row] ?? 0)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{

        switch kind {

        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellName.exerciseDetailsHeader, for: indexPath as IndexPath) as! exerciseDetailsHeader
            
            if indexPath.section == 0 && items.count>0{
                headerView.lblHeader.text = "Exercises"
            }else {
                headerView.lblHeader.text = "Variations"
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
                return UICollectionReusableView()

        default:

            assert(false, "Unexpected element kind")
        }
        fatalError("Unexpected element kind")

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: collectionView.frame.width / 3.5 , height: 150)
        }else{
            return CGSize(width: collectionView.frame.width / 3.5 , height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width:collectionView.frame.size.width, height:50.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && items.count>0{
            return
        }
        if indexPath.section == 1 && details?.excDetails.variations?.count ?? 0 > 0{
        NotificationCenter.default.post(name: .pushVariations, object:String(details?.excDetails.variations?[indexPath.row] ?? 0), userInfo: nil)
        }else{
            NotificationCenter.default.post(name: .pushVariations, object:String(details?.excDetails.variations?[indexPath.row] ?? 0), userInfo: nil)
        }

    }
}
