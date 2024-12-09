//
//  DogLikeTests.swift
//  DogLikeTests
//
//  Created by Lars Nicodemus on 09.12.24.
//

import XCTest
@testable import DogLike
final class DogLikeTests: XCTestCase {
    

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        
    }

    @MainActor
    func testNameInput() throws {
        let dogVM: DogViewModel = DogViewModel()
        let name = "Lars"
        XCTAssertTrue(dogVM.greeting(name: name) == "Welcome to DogLike, \(name)!", "Der Name ist falsch")
    }
    @MainActor
    func testDogBreed() throws {
        let dogVM: DogViewModel = DogViewModel()
        let breedName = "pembroke"
        XCTAssertTrue(dogVM.extractBreedName(from: "https://images.dog.ceo/breeds/pembroke/n02113023_2330.jpg") == breedName, "Der Name der Rasse ist falsch")
    }
    @MainActor
    func testDogBreedNotNil() throws {
        let dogVM: DogViewModel = DogViewModel()
        XCTAssertNotNil(dogVM.extractBreedName(from: "https://images.dog.ceo/breeds/pembroke/n02113023_2330.jpg") , "Der Name der Rasse ist nicht gegeben, Rückgabe ist nil ")
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
