//
//  HomeExercisesVC.swift
//  AssignmentGymondo
//
//  Created by Amit
//

import UIKit
import SDWebImage

class HomeExercisesVC: UIViewController,UITableViewDelegate {
    
    //UI Objects
    @IBOutlet weak var exercisesTableView: UITableView!
    private var exercisesViewModel : ExercisesViewModel!
    private var dataSource : EexercisesTableViewDataSource<tblExerciseCell,ExercisesData>!

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: Setup on view load
    func setupView(){
        //register tableview cell nib
        exercisesTableView.register(UINib(nibName: cellName.excercise, bundle: nil), forCellReuseIdentifier: cellName.excercise)
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        //Check intenet connectivity
        if InternetConnectionManager.isConnectedToNetwork(){
            DispatchQueue.main.async {
                Helper.startProgress(viewController: self)
            }
        self.exercisesViewModel =  ExercisesViewModel()
        self.exercisesViewModel.bindExercisesViewModelToController = {
            self.updateDataSource()
            DispatchQueue.main.async {
                Helper.stopProgress(viewController: self)
            }
         }
        }else{
            //present alert if internet not connected
            Helper.stopProgress(viewController: self)
            let alertWithCompletionAndCancel = Alert.errorAlert(title: alert.Title, message: alert.CheckInternetConnectivity, cancelButton: true) {
                self.callToViewModelForUIUpdate()
               }
            present(alertWithCompletionAndCancel, animated: true)
        }
    }
    
    func updateDataSource(){
        //update tableview data source by getting the data from view model
        self.dataSource = EexercisesTableViewDataSource(cellIdentifier: cellName.excercise, items: self.exercisesViewModel.excData.results, configureCell: { (cell, evm) in
            cell.lblExercise.text = evm.name
            cell.imgExercise.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgExercise.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "dummyplaceholder"))
        })
        
        DispatchQueue.main.async {
            self.exercisesTableView.dataSource = self.dataSource
            self.exercisesTableView.reloadData()
        }
    }
    
    //push view controller on cell tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExercisesDetailsVC") as! ExercisesDetailsVC
        vc.arrData = self.exercisesViewModel.excData.results[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


