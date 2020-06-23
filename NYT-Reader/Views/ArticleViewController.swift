//
//  ArticleViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/17/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    //VARS
    var article: Shared?
    
    
    //OUTLETS
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleAbstract: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    //ACTIONS
    @IBAction func testButton(_ sender: UIButton) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "OptionsView")
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
//        optionsVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        present(popController, animated: true)
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let article = article else {
            return
        }
        articleTitle.text = article.title
        articleSource.text = article.source
        articleAbstract.text = article.abstract
        articleDate.text = convertDateType(published_Date: article.published_date)
        loadImages()
    }
    
    
    func loadImages() {
        guard let article = article else {return}
        guard !article.media.isEmpty else {return}
        articleImageView.load(urlString: article.media[0].mediaMetaData[0].url)
    }
    
}

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
    
}
