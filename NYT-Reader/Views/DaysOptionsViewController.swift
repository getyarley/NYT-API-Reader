//
//  DaysOptionsViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/21/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class DaysOptionsViewController: UIViewController {

    //VARS
    public var delegate: PopupDelegate?
    var currentArticleType: ArticleType!
    var currentDaysViewed: DaysViewed!
    var buttons: [UIButton]?
    var buttonDict: [DaysViewed: UIButton] = [:]
    
    //OBJECTS
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var sevenDaysButton: UIButton!
    @IBOutlet weak var thirtyDaysButton: UIButton!
    
    //ACTIONS
    @IBAction func dayAction(_ sender: UIButton) {
        delegate?.popupDidDisappear(articleType: currentArticleType, daysViewed: .one)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sevenDaysAction(_ sender: UIButton) {
        delegate?.popupDidDisappear(articleType: currentArticleType, daysViewed: .seven)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thirtyDaysAction(_ sender: UIButton) {
        delegate?.popupDidDisappear(articleType: currentArticleType, daysViewed: .thirty)
        dismiss(animated: true, completion: nil)
    }
    
    
    //VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [dayButton, sevenDaysButton, thirtyDaysButton]
        buttonDict[DaysViewed.one] = dayButton
        buttonDict[DaysViewed.seven] = sevenDaysButton
        buttonDict[DaysViewed.thirty] = thirtyDaysButton
        customizeButtons()
    }

    
    //FUNCS
    func customizeButtons() {
        guard let buttons = buttons else {return}
        for button in buttons {
            button.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.334).isActive = true
            button.clipsToBounds = true
            
            if button == buttonDict[currentDaysViewed] {
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 15
            }
        }
        
    }
    
    
}
