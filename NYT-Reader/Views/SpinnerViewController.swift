//
//  SpinnerViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/21/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

    //VARS
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
