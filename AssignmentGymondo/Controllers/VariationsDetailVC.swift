//
//  VariationsDetailVC.swift
//  AssignmentGymondo
//
//  Created by Amit
//

import UIKit

class VariationsDetailVC: UIViewController {
    //UI Objects
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    private var exercisesDetailsViewModel : ExercisDetailsViewModel!

    //variations ID
    var strVariationsID : String!

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: Setup on view load
    func setupView(){
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        if InternetConnectionManager.isConnectedToNetwork(){
            DispatchQueue.main.async {
                Helper.startProgress(viewController: self)
            }
        self.exercisesDetailsViewModel =  ExercisDetailsViewModel(strExercisID: "\(strVariationsID!)")
        self.exercisesDetailsViewModel.bindExerciseDetailsVMToController = {
            DispatchQueue.main.async {
                self.lblTitle.text = self.exercisesDetailsViewModel.excDetails.name
                if let labelTextFormatted = self.exercisesDetailsViewModel.excDetails.description?.htmlToAttributedString {
                                let textAttributes = [
                                    NSAttributedString.Key.foregroundColor: UIColor.black,
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
                                ] as [NSAttributedString.Key: Any]
                                labelTextFormatted.addAttributes(textAttributes, range: NSRange(location: 0, length: labelTextFormatted.length))
                    self.tvDescription.attributedText = labelTextFormatted
                            }
                Helper.stopProgress(viewController: self)
            }
         }
        }
        else{
            //present alert if internet not connected
            Helper.stopProgress(viewController: self)
            let alertWithCompletionAndCancel = Alert.errorAlert(title: alert.Title, message: alert.CheckInternetConnectivity, cancelButton: true) {
                self.callToViewModelForUIUpdate()
               }
            present(alertWithCompletionAndCancel, animated: true)
        }
        
    }
    
    @IBAction func backAction(sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
}
extension String {

 var htmlToAttributedString: NSMutableAttributedString? {
    guard let data = data(using: .utf8) else { return nil }
    do {
        return try NSMutableAttributedString(data: data,
                                      options: [.documentType: NSMutableAttributedString.DocumentType.html,
                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                      documentAttributes: nil)
    } catch let error as NSError {
        print(error.localizedDescription)
        return  nil
    }
 }

}
