//
//  RatingControl.swift
//  FoodTrackerApp
//
//  Created by Arsalan Wahid Asghar on 11/27/17.
//  Copyright © 2017 Arsalan Wahid Asghar. All rights reserved.
//

import UIKit
@IBDesignable
class RatingControl: UIStackView {
    
    //MARK:- Properties
    
    private var ratingButtons = [UIButton]()
    var rating = 0{
        didSet{
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setUpButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5{
        didSet{
            setUpButtons()
        }
    }
    
    
    
    //MARK:- Initializers
    
    //Loads this programatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    //MARK:- Private methods
    
    private func setUpButtons(){
        
        //Remove already Existing Buttons
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
       
        
        for index in 0..<starCount{
            //Create Button
            let button = UIButton()
            button.accessibilityLabel = "set \(index + 1) star rating"
            //button.backgroundColor = .red
            
            //Load the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //Set Button Constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Associate action method via code for button
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
        //Updates Rating selected by user
        updateButtonSelectionStates()
    }
    
    
    
    //MARK:- Button Action
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
            let hintString:String?
            if rating == index + 1{
                hintString = "Tap to reset the rating to zero"
            }else{
                hintString = nil
            }
         
            //calculate the value string
            let valueString:String
            switch(rating){
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 Star set"
            default:
                valueString = "\(rating) is set"
            }
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
