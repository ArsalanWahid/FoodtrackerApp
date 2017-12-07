//
//  MealViewController.swift
//  FoodTrackerApp
//
//  Created by Arsalan Wahid Asghar on 11/26/17.
//  Copyright © 2017 Arsalan Wahid Asghar. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveMealButton: UIBarButtonItem!
    
    var meal: Meal?
    
    
    
    //MARK:- Behaviour Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        //onload the save button is disabled LOL !
        updateSaveButtonStatus()
        
        //Set views if editing a meal
        if let meal = meal{
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
    }
    
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //On return key pressed on the keyboard this method will resign the current textfield first reponder and give it some appropriate object
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        //Don't allow the user to use save button without adding text
        updateSaveButtonStatus()
        navigationItem.title = nameTextField.text
        
    }
    
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //picker is the imagepicker setup & then the info is the string with the image being selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image ,but recieved,\(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Navigation
    //Exeute Custom code when segue performed from this controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Check if the button pressed is for sure the save button
        guard let button = sender as? UIBarButtonItem, button === saveMealButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK:- Actions
    
    @IBAction func selectPhotoFromLibrary(_ sender: UITapGestureRecognizer) {
        //Makes sure keyboard is hidden when user taps image
        nameTextField.resignFirstResponder()
        
        //UIimagePickerController is a view that lets the user pick image from library
        let imagePickercontroller = UIImagePickerController()
        
        //Set the picker to only allow user to select photos from library
        imagePickercontroller.sourceType = .photoLibrary
        imagePickercontroller.delegate = self
        present(imagePickercontroller, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Private methods
    private func updateSaveButtonStatus(){
        //Will only enable the save button when there is text in the text field
        let text = nameTextField.text ?? ""
        saveMealButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func cancelMeal(_ sender: UIBarButtonItem) {
        //depending on the style of presentation this view need to dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        //This is for modally presentaion
        if isPresentingInAddMealMode{
            dismiss(animated: true, completion: nil)
        }//This is cause edit pushes controller on stack
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else{
            fatalError("MealViewController is not in Navigation Stack")
        }
    }
}

