//
//  APIService.swift
//  AssignmentGymondo
//
//  Created by Amit on 02/05/22.
//

import UIKit

class APIService: NSObject {
    private let sourcesURL = URL(string: API.baseURL + API.excercises)!
    
    func apiToGetExerciseData(completion : @escaping (Exercises) -> ()){

        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let excData = try! jsonDecoder.decode(Exercises.self, from: data)
            
                    completion(excData)
            }
            
        }.resume()
    }
    
    func apiToGetExerciseDetails(sourceURL:URL,completion : @escaping (ExerciseDetail) -> ()){
        URLSession.shared.dataTask(with: sourceURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                let excData = try! jsonDecoder.decode(ExerciseDetail.self, from: data)
            
                    completion(excData)
            }
            
        }.resume()
    }
    
}
