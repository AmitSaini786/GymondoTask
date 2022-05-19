//
//  ExercisesDetailsVC.swift
//  AssignmentGymondo
//
//  Created by Amit
//

import UIKit
import SDWebImage

class ExercisesDetailsVC: UIViewController,UICollectionViewDelegateFlowLayout{
    //UI Objects
    @IBOutlet weak var exercisesCV: UICollectionView!
    @IBOutlet weak var lblExercisesName: UILabel!

    private var exercisesDetailsViewModel : ExercisDetailsViewModel!
    private var dataSource : ExerciseCVViewDataSource<CVExerciseImageCell,Image>!
    
    //exercise ID
    var strExercisesID : String?
    var arrData : ExercisesData!

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: Setup on view load
    func setupView(){
        
        //register collectionview cell nib
        exercisesCV.register(UINib(nibName: cellName.exerciseImageCell, bundle: .main), forCellWithReuseIdentifier: cellName.exerciseImageCell)

        exercisesCV.register(UINib(nibName:cellName.exerciseDetailsHeader, bundle: Bundle.main),
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier:cellName.exerciseDetailsHeader)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushToVariations(notification:)), name: .pushVariations, object: nil)

        lblExercisesName?.text = arrData.name

        let width = (exercisesCV.frame.width)
        let layout = exercisesCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = CGSize(width: width / 3, height: exercisesCV.frame.size.height / 4)
        exercisesCV.setCollectionViewLayout(layout, animated: true)
        layout.headerReferenceSize = CGSize(width: exercisesCV.frame.size.width, height: 100)
        
        //call view model to update User interface
        ///view model send request to API service class to get the data from server and after getting response from server view API service return the data in the form of model
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        //check for internet connectivity
        if InternetConnectionManager.isConnectedToNetwork(){
        self.exercisesDetailsViewModel =  ExercisDetailsViewModel(strExercisID: "\(arrData.id)")
        self.exercisesDetailsViewModel.bindExerciseDetailsVMToController = {
            DispatchQueue.main.async {
                Helper.startProgress(viewController: self)
            }
            self.updateDataSource()
         }
        }else{
            //present alert if internet not connected
            Helper.stopProgress(viewController: self)
            let alertWithCompletionAndCancel = Alert.errorAlert(title: alert.Title, message: alert.CheckInternetConnectivity, cancelButton: true) {
                //request view model for data when internet is back
                self.callToViewModelForUIUpdate()
               }
            present(alertWithCompletionAndCancel, animated: true)
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async {
            Helper.stopProgress(viewController: self)
        }
        //update tableview data source by getting the data from view model
        self.dataSource = ExerciseCVViewDataSource(cellIdentifier: cellName.exerciseImageCell, items: self.exercisesDetailsViewModel.excDetails.images, configureCell: { (cell, evm) in
            cell.imgExercise.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgExercise.sd_setImage(with: URL(string: evm.image!), placeholderImage: UIImage(named: "dummyplaceholder"))
            cell.imgExercise.layer.cornerRadius = 8
            cell.imgExercise.layer.masksToBounds = true
        })
        self.dataSource.details = self.exercisesDetailsViewModel

        DispatchQueue.main.async {
            self.exercisesCV.dataSource = self.dataSource
            self.exercisesCV.delegate = self.dataSource
            self.exercisesCV.reloadData()
          }
    }
    
    //Helper to push to variations view controller
    @objc func pushToVariations(notification: NSNotification) {
        if let strVariationID = notification.object {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: vcName.variationsDetailVC) as! VariationsDetailVC
            vc.strVariationsID = String(format: "%@", strVariationID as! CVarArg)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //MARK : Pop back action
    @IBAction func backAction(sender:Any){
        self.navigationController?.popViewController(animated: true)
    }

}
