//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Volodymyr Myroniuk on 10/9/18.
//  Copyright © 2018 Volodymyr Myroniuk. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            self.setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            self.setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = self.ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingbuttons array: \(self.ratingButtons)")
        }
        
        // Calculate the rating of the selected button.
        let selectedRating = index + 1
        
        if selectedRating == self.rating {
            // If the selected start represents the current rating, reset the rating to 0.
            self.rating = 0
        } else {
            // Otherwise set the rating to the selected star.
            self.rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        // Clear any existing buttons.
        for button in self.ratingButtons {
            self.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        self.ratingButtons.removeAll()
        
        // Load buttons images.
        let bundle = Bundle(for: type(of: self))
        let filledStart = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<self.starCount {
            // Create the button.
            let button = UIButton()
            
            // Set the button images.
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStart, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints.
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: self.starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.starSize.width).isActive = true
            
            // Setup the button action.
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)),
                             for: .touchUpInside)
            
            // Add the button to the stack.
            self.addArrangedSubview(button)
            
            // Add the new button for the rating button array.
            self.ratingButtons.append(button)
        }
        
        self.updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in self.ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
}
