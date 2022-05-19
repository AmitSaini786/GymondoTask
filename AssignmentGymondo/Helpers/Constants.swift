//
//  Constants.swift
//  AssignmentGymondo
//
//  Created by Amit on 03/05/22.
//

import Foundation

struct alert {
    static let Title = "Gymondo"
    static let CheckInternetConnectivity = "Please Check Internet connectivity and try again."
}
struct cellName {
    static var excercise: String = "tblExerciseCell"
    static var exerciseImageCell: String = "CVExerciseImageCell"
    static var exerciseDetailsHeader: String = "exerciseDetailsHeader"
}

struct vcName {
    static var exercisesDetailsVC: String = "ExercisesDetailsVC"
    static var variationsDetailVC: String = "VariationsDetailVC"

}

struct API {
    static let getExerciseDetails = "exerciseinfo"
    static let baseURL = "https://wger.de/api/v2/"
    static let excercises = "exercise"
}

//MARK: Notification Center
extension Notification.Name {
    static let pushVariations = Notification.Name("pushVariations")
}
