//
//  MealTableViewController.swift
//  FoodTrackerApp
//
//  Created by Arsalan Wahid Asghar on 11/28/17.
//  Copyright © 2017 Arsalan Wahid Asghar. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    
    //MARK:- Properties
    var meals = [Meal]()
    
    //MARK:- Private Methods
    func loadSmapleMeals(){
        
        let bundle = Bundle(for: type(of: self))
        let photo1 = UIImage(named: "meal1", in: bundle, compatibleWith: self.traitCollection)
        let photo2 = UIImage(named:"meal2", in: bundle, compatibleWith: self.traitCollection)
        let photo3 = UIImage(named:"meal3", in: bundle, compatibleWith: self.traitCollection)
//        let photo1 = UIImage(named: "meal1")
//        let photo2 = UIImage(named: "meal2")
//        let photo3 = UIImage(named: "meal3")
//
        
        guard let meal1 = Meal(name: "fuckshit", photo: photo1, rating: 2) else{
            fatalError("Something bad happened while making meal object")}
        
        guard let meal2 = Meal(name: "Burget", photo: photo2, rating: 4) else{
            fatalError("Something bad happened while making meal object")
        }
        
        guard let meal3 = Meal(name: "Tasty Salad", photo: photo3, rating: 5) else{
            fatalError("Something bad happened while presenting tasty salad")
        }
        
        
        //Add Meals created to meals array to be presernted
        meals += [meal1,meal2, meal3]
    }
    
    //Loads the Meals from the Specific Document Path in App
    
    private func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    //Saves the Meals to the Path defined in the Meal Model Class
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    
    //MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
       //Special bar button that allows rows to be edited
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedMeals = loadMeals(){
            meals += savedMeals
        }else{
         loadSmapleMeals()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "meatTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The Dequed cell is not a member of MeatTableViewCell")
        }

        //Now have to fetch the data as well
        let meal = meals[indexPath.row]
         cell.nameLabel.text = meal.name
         cell.photoImageView.image = meal.photo
         cell.ratingControl.rating = meal.rating
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert{
            //create new instance of appropriate class
        }
    }
    
    
    //MARK:- Navigation
    
    
    //Execute custom code when segue performed from this controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
       
        case "AddItem":
            os_log("Adding new meal", log: OSLog.default, type: .default)
            
            //This case check if the meal view controller is being segued to ..
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else{
                fatalError("Unexpected destination \(segue.destination) ")
            }
            
            //Check if the sender was a MealTableViewCell or not
            guard let selectedMealCell = sender as? MealTableViewCell else{
                fatalError("Inexpected tableview cell \(sender ?? "error") ")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else{
                fatalError("Selected cell is not being displayed by the tableview")
            }
            
            //Select the meal store in the array
            let selectdMeal = meals[indexPath.row]
            //Assign the object info to the meal of the new UIviewcontroller of type mealViewController
            mealDetailViewController.meal = selectdMeal
            
        default:
            fatalError("Unexpected segue Indentifier \(segue.identifier)")
        }
    }
    
    
    
    

    //MARK:- Actions
    
    //Acts when ever segue is return to this controller
    @IBAction func unwindToMealList(sender: UIStoryboardSegue)
    {
        
        //this is to make sure that the object being passed is for the MealViewController meal incase there are other unwinds coming to the destination controller
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            
            //Update existing meal if edited
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                meals[selectedIndexPath.row] = meal
             tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            saveMeals()
        }
    }
    
}//Class end
