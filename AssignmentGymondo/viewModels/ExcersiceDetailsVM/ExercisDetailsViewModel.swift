//
//  ExercisDetailsViewModel.swift
//  AssignmentGymondo
//
//  Created by Amit on 03/05/22.
//

import UIKit

class ExercisDetailsViewModel: NSObject {

    private var apiService : APIService!
    var strExercisID : String?
    private(set) var excDetails : ExerciseDetail! {
        didSet {
            self.bindExerciseDetailsVMToController()
        }
    }
    
    var bindExerciseDetailsVMToController : (() -> ()) = {}
    
     init(strExercisID:String) {
        super.init()
        self.apiService =  APIService()
         callFuncToGetExcDetails(strExercisID: strExercisID)
    }
    
    //Get Exercise derails data from server
    func callFuncToGetExcDetails(strExercisID:String) {
        self.apiService.apiToGetExerciseDetails(sourceURL: URL(string: API.baseURL + API.getExerciseDetails + "/\(strExercisID)")!) { excDetails in
        self.excDetails = excDetails
        }
    }
}
