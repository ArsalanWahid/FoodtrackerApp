//
//  meal.swift
//  FoodTrackerApp
//
//  Created by Arsalan Wahid Asghar on 11/28/17.
//  Copyright © 2017 Arsalan Wahid Asghar. All rights reserved.
//

import UIKit
import os.log


class Meal : NSObject, NSCoding{
    
    //MARK:- NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey
            .name) as? String else{
                os_log("Unable to decode name for Meal object", log: OSLog.default, type: .debug)
                return nil
            }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
        }
    
    
    //Creates a Path for app to store data 
    //MARK:- Archive Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    
    //MARK:- Properties
    var name: String
    var photo: UIImage?
    var rating:Int
    
    //The ? means that this is a failable initializer
    init?(name:String, photo:UIImage?, rating:Int) {
    
        //Name must not be empty
        guard !name.isEmpty else{
            return nil
        }
        
        //rating should be between 0-5
        guard (rating >= 0) && (rating <= 5) else{
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    
    }
    
    
    //Implementing DATA PERSISTANCE
    
    //MARK:- Types
    
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
   

}


        

