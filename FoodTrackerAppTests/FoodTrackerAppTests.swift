//
//  FoodTrackerAppTests.swift
//  FoodTrackerAppTests
//
//  Created by Arsalan Wahid Asghar on 11/28/17.
//  Copyright © 2017 Arsalan Wahid Asghar. All rights reserved.
//

import XCTest
@testable import FoodTrackerApp


class FoodTrackerAppTests: XCTestCase {
    
    //MARK:- Meal test cases
    
    
    //Confirm that the Meal class initilizer return valid Meal Object when provided with valid parameters
    
    func testMealInitializerSucceeds(){
        //ZeroRating
    
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Highest positive rating
        
        let highestRatingmeal = Meal.init(name: "Highest", photo: nil, rating: 5)
        XCTAssertNotNil(highestRatingmeal)
    }
    
    
    func testMealInitializationFails(){
        
        //Negative Rating
        let negativeRatingMeal = Meal.init(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //Empty Meal name String
        let emtpyMealNameString = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emtpyMealNameString)
        
        //Rating exceeds maximum limit
        let exceedsRatingMaximum = Meal.init(name: "large", photo: nil, rating: 6)
        XCTAssertNil(exceedsRatingMaximum)
    
    }
    
    
   
    
}
