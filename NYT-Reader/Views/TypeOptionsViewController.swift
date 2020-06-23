//
//  OptionsViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/18/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class TypeOptionsViewController: UIViewController {
    
    //VARS
    public var delegate: PopupDelegate?
    var currentArticleType: ArticleType!
    var currentDaysViewed: DaysViewed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [mostViewedButton, mostSharedButton, mostEmailedButton]
        buttonDict[ArticleType.viewed] = mostViewedButton
        buttonDict[ArticleType.shared] = mostSharedButton
        buttonDict[ArticleType.emailed] = mostEmailedButton
        customizeButtons()
    }
    
    
    //ACTIONS
    @IBAction func mostViewed(_ sender: UIButton) {
        delegate?.popupDidDisappear(articleType: .viewed, daysViewed: currentDaysViewed)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func mostShared(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.popupDidDisappear(articleType: .shared, daysViewed: currentDaysViewed)
    }
    
    @IBAction func mostEmailed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.popupDidDisappear(articleType: .emailed, daysViewed: currentDaysViewed)
    }
    
    //OBJECTS
    var buttons: [UIButton]?
    var buttonDict: [ArticleType: UIButton] = [:]
    @IBOutlet weak var mostViewedButton: UIButton!
    @IBOutlet weak var mostSharedButton: UIButton!
    @IBOutlet weak var mostEmailedButton: UIButton!
    
    
    func customizeButtons() {
        guard let buttons = buttons else {return}
        for button in buttons {
            button.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.334).isActive = true
            button.clipsToBounds = true
            
            if button == buttonDict[currentArticleType] {
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 15
            }
        }
    }
}
