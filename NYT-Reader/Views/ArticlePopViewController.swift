//
//  ArticlePopViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/21/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class ArticlePopViewController: UIViewController {

    //VARS
    var article: Article?
    public var delegate: BookmarkDelegate?
        
    
    //OUTLETS
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    //ACTIONS
    @IBAction func bookmarkAction(_ sender: UIButton) {
        showAlert()
//        self.article?.bookmarked.toggle()
//        bookmark(currentState: self.article!.bookmarked)
//        //SAVE FUNC HERE
//        guard let article = article else {return}
//        delegate?.toggleBookmark(newArticleID: article.shared.id)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let article = article else {
            print("No Article type provided")
            return
        }
        
        guard let bookmarkedImage = UIImage(systemName: "bookmark.fill") else {return}
        guard let bookmarkImage = UIImage(systemName: "bookmark") else {return}
        if !article.bookmarked {
            bookmarkButton.setImage(bookmarkImage, for: .normal)
        } else {
            bookmarkButton.setImage(bookmarkedImage, for: .normal)
        }
        
        dateLabel.text = convertDateType(published_Date: article.shared.published_date)
        titleLabel.text = article.shared.title
        abstractLabel.text = article.shared.abstract
        sourceLabel.text = article.shared.source
        
        articleView.layer.cornerRadius = 10
        bookmarkButton.setTitle("", for: .normal)
        bookmarkButton.tintColor = .black
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapRecognizer)
        
        let disabledTapRecognizer = UITapGestureRecognizer(target: self, action: nil)
        articleView.addGestureRecognizer(disabledTapRecognizer)
    }
    
    //FUNCS
    func animateArticleView() {
        UIView.transition(with: articleView, duration: 0.3, options: .curveEaseInOut, animations: {
            self.articleView.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
    }
    
    func showAlert() {
        guard var article = article else {return}
        if article.bookmarked {
            let alertVC = UIAlertController(title: "Are you sure you want to remove from Bookmarks?", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self, weak alertVC] _ in
                article.bookmarked.toggle()
                self?.bookmark(currentState: article.bookmarked)
                //SAVE FUNC HERE
                self?.delegate?.toggleBookmark(newArticleID: article.shared.id)
                self?.dismissView()
            })
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default))
            present(alertVC, animated: true)
        } else {
            article.bookmarked.toggle()
            bookmark(currentState: article.bookmarked)
            delegate?.toggleBookmark(newArticleID: article.shared.id)
        }
    }
    
    
    
    //OBJC FUNCS
    @objc func bookmark(currentState: Bool) {
        guard let bookmarkedImage = UIImage(systemName: "bookmark.fill") else {return}
        guard let bookmarkImage = UIImage(systemName: "bookmark") else {return}
        
        if !currentState {
            bookmarkButton.setImage(bookmarkImage, for: .normal)
        } else {
            bookmarkButton.setImage(bookmarkedImage, for: .normal)
        }
    }
    
    
    //OBJC FUNCS
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}
