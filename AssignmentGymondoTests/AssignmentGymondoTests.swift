//
//  AssignmentGymondoTests.swift
//  AssignmentGymondoTests
//
//  Created by Amit on 02/05/22.
//

import XCTest
@testable import AssignmentGymondo

class AssignmentGymondoTests: XCTestCase {

    private var exercisesViewModel : ExercisesViewModel!
    private var exercisesDetailsViewModel : ExercisDetailsViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        exercisesViewModel =  ExercisesViewModel()
        exercisesDetailsViewModel =  ExercisDetailsViewModel(strExercisID: "38")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        exercisesViewModel =  nil
        exercisesViewModel =  nil
    }
    
    func testCallToViewModelForUIUpdateList() throws{
        exercisesViewModel.bindExercisesViewModelToController = {
        }
    }

    func testCallToViewModelForUIUpdateDetails() throws{
        exercisesDetailsViewModel.bindExerciseDetailsVMToController = {
        }
    }
    
    func testPerformance() {
        measure(
          metrics: [
            XCTClockMetric(),
            XCTCPUMetric(),
            XCTStorageMetric(),
            XCTMemoryMetric()
          ]
        ) {
//          sut.check(guess: 100)
        }
    }


}
