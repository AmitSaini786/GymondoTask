//
//  ExercisesViewModel.swift
//  AssignmentGymondo
//
//  Created by Amit
//

import UIKit

class ExercisesViewModel: NSObject {

    private var apiService : APIService!

    private(set) var excData : Exercises! {
        didSet {
            self.bindExercisesViewModelToController()
        }
    }
    
    var bindExercisesViewModelToController : (() -> ()) = {}

    override init() {
        super.init()
        self.apiService =  APIService()
        callFuncToGetExcData()
    }
    
    //Get Exercise data from server
    func callFuncToGetExcData() {
        self.apiService.apiToGetExerciseData { (excData) in
            self.excData = excData
        }
    }
    
}
