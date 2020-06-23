//
//  ViewController.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/16/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import UIKit

class MainPageViewController: UITableViewController, UIPopoverPresentationControllerDelegate, PopupDelegate, BookmarkDelegate {

    //VARS
    var mostPopularArticles = [Article]()
    var bookmarkedArticles = [Article]()
    var loadedArticleType: ArticleType!
    var loadedDaysViewed: DaysViewed!
    var spinnerView: SpinnerViewController!
    var showBookmarkArticles: Bool = false
    
    
    //VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(load), with: nil)
        createSpinnerView()
        loadedArticleType = .viewed
        loadedDaysViewed = .one
        title = "Most " + loadedArticleType.rawValue.capitalized
        loadFromJSON(articleType: loadedArticleType, daysViewed: loadedDaysViewed)
        setupBarButtons()
    }
    
    //BUTTON + VIEW SETUP
    func setupBarButtons() {
        //TYPE
        guard let articleImage = UIImage(systemName: "line.horizontal.3") else {return}
        let articleButton = UIButton(type: UIButton.ButtonType.custom)
        articleButton.setImage(articleImage, for: .normal)
        articleButton.imageView?.tintColor = .black
        articleButton.addTarget(self, action: #selector(displayTypeOptions(_:)), for: .touchUpInside)
        articleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        let articleBarButton = UIBarButtonItem(customView: articleButton)
        
        //DAYS
        guard let daysImage = UIImage(systemName: "calendar") else {return}
        let daysButton = UIButton(type: UIButton.ButtonType.custom)
        daysButton.setImage(daysImage, for: .normal)
        daysButton.imageView?.tintColor = .black
        daysButton.addTarget(self, action: #selector(displayDayOptions(_:)), for: .touchUpInside)
        daysButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        let daysBarButton = UIBarButtonItem(customView: daysButton)
        
        navigationItem.rightBarButtonItems = [articleBarButton, daysBarButton]
        
        guard let bookmarkImage = UIImage(systemName: "bookmark") else {return}
        let bookmarkButton = UIButton(type: UIButton.ButtonType.custom)
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        bookmarkButton.imageView?.tintColor = .black
        bookmarkButton.addTarget(self, action: #selector(showBookmarks), for: .touchUpInside)
        bookmarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        let bookmarkBarButton = UIBarButtonItem(customView: bookmarkButton)
        
        navigationItem.leftBarButtonItem = bookmarkBarButton
    }
    
    
    //TABLE SETUP
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showBookmarkArticles {
            return bookmarkedArticles.count
        } else {
            return mostPopularArticles.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("FAILURE")
        }
        
        if showBookmarkArticles {
            cell.title.text = bookmarkedArticles[indexPath.row].shared.title
            cell.abstract.text = bookmarkedArticles[indexPath.row].shared.abstract
            cell.source.text = bookmarkedArticles[indexPath.row].shared.source
            let date = convertDateType(published_Date: bookmarkedArticles[indexPath.row].shared.published_date)
            cell.date.text = date
        } else {
            cell.title.text = mostPopularArticles[indexPath.row].shared.title
            cell.abstract.text = mostPopularArticles[indexPath.row].shared.abstract
            cell.source.text = mostPopularArticles[indexPath.row].shared.source
            let date = convertDateType(published_Date: mostPopularArticles[indexPath.row].shared.published_date)
            cell.date.text = date
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showBookmarkArticles {
            popArticle(self, article: bookmarkedArticles[indexPath.row])
                tableView.deselectRow(at: indexPath, animated: true)
        } else {
            popArticle(self, article: mostPopularArticles[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showBookmarkArticles {
            return "Bookmarks"
        } else if loadedDaysViewed.rawValue == DaysViewed.one.rawValue {
            return "Last 24 hours"
        } else {
            let title = "Last " + loadedDaysViewed.rawValue + " days"
            return title
        }
    }
    
    
    
    //@OBJC FUNCS
    @objc func displayTypeOptions(_ sender: Any) {
        let optionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TypeOptionsView") as! TypeOptionsViewController
        optionsVC.modalPresentationStyle = .popover
        optionsVC.preferredContentSize = CGSize(width: 150, height: 150)
        
        let popover = optionsVC.popoverPresentationController
        popover?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        popover?.sourceView = sender as? UIView
        popover?.delegate = self
        optionsVC.delegate = self
        
        optionsVC.currentArticleType = loadedArticleType
        optionsVC.currentDaysViewed = loadedDaysViewed
        present(optionsVC, animated: true, completion: nil)
    }
    
    @objc func displayDayOptions(_ sender: Any) {
        let optionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DaysOptionsView") as! DaysOptionsViewController
        optionsVC.modalPresentationStyle = .popover
        optionsVC.preferredContentSize = CGSize(width: 150, height: 150)
        
        let popover = optionsVC.popoverPresentationController
        popover?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        popover?.sourceView = sender as? UIView
        popover?.delegate = self
        optionsVC.delegate = self
        
        optionsVC.currentArticleType = loadedArticleType
        optionsVC.currentDaysViewed = loadedDaysViewed
        present(optionsVC, animated: true, completion: nil)
    }
    
    
    @objc func showBookmarks() {
        if self.showBookmarkArticles {
            self.showBookmarkArticles.toggle()
            setupBarButtons()
            DispatchQueue.main.async {
                UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            }
            return
        } else {
            self.showBookmarkArticles.toggle()
            navigationItem.rightBarButtonItems = []
            navigationItem.leftBarButtonItems = []
            
            guard let bookmarkedImage = UIImage(systemName: "bookmark.fill") else {return}
            let bookmarkButton = UIButton(type: UIButton.ButtonType.custom)
            bookmarkButton.setImage(bookmarkedImage, for: .normal)
            bookmarkButton.imageView?.tintColor = .black
            bookmarkButton.addTarget(self, action: #selector(showBookmarks), for: .touchUpInside)
            bookmarkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
            let bookmarkBarButton = UIBarButtonItem(customView: bookmarkButton)
            
            navigationItem.leftBarButtonItem = bookmarkBarButton
            DispatchQueue.main.async {
                UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            }
        }
    }
    
    
    
    //FUNCS
    func popArticle(_ sender: Any, article: Article) {
        let popVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SelectedArticle") as! ArticlePopViewController
        popVC.modalPresentationStyle = .overCurrentContext
        popVC.modalTransitionStyle = .crossDissolve
        popVC.article = article
        popVC.delegate = self
        
        present(popVC, animated: true)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }
    
    
    
    //JSON FUNCS
    func loadFromJSON(articleType: ArticleType, daysViewed: DaysViewed) {
        DataLoader.LoadURLData(articleType: articleType, daysViewed: daysViewed) { (data) in
            guard let loadedData = data else {return}
            self.parse(json: loadedData)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode(SharedArticles.self, from: json) {
            for index in 0..<jsonData.results.count {
                self.mostPopularArticles.append(Article(bookmarked: false, shared: jsonData.results[index]))
            }
            
            DispatchQueue.main.async {
                self.title = "Most " + self.loadedArticleType.rawValue.capitalized
                UIView.transition(with: self.tableView, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {self.tableView.reloadData()}, completion: nil)
                UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.spinnerView.view.removeFromSuperview()}, completion: nil)
            }
        } else {
            print("Error decoding JSON")
        }
    }
    
    
    //LOADING SPINNER VIEW
    func createSpinnerView() {
        let child = SpinnerViewController()
        spinnerView = child
        
        addChild(child)
        child.view.frame = view.frame
        UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {self.view.addSubview(child.view)}, completion: nil)
        child.didMove(toParent: self)
    }
    
    
    
    //BOOKMARK FUNCS
    func toggleBookmark(newArticleID: Int) {
        guard var newArticle = mostPopularArticles.first(where: {$0.shared.id == newArticleID}) else {
            print("Article not found")
            return
        }
        guard let articleIndex = mostPopularArticles.firstIndex(where: {$0.shared.id == newArticleID}) else {
            print("Article not found")
            return
        }
        
        mostPopularArticles[articleIndex].bookmarked.toggle()
        
        if let bookmarkedIndex = bookmarkedArticles.firstIndex(where: {$0.shared.id == newArticleID}) {
            bookmarkedArticles.remove(at: bookmarkedIndex)
            save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            newArticle.bookmarked = true
            bookmarkedArticles.append(newArticle)
            save()
        }
    }
    
    
    //PROTOCOL FUNCS
    func popupDidDisappear(articleType: ArticleType, daysViewed: DaysViewed) {
        createSpinnerView()
        if loadedArticleType == articleType && loadedDaysViewed == daysViewed {
            print("No change")
            return
        }
        
        mostPopularArticles.removeAll()
        loadedArticleType = articleType
        loadedDaysViewed = daysViewed
        loadFromJSON(articleType: articleType, daysViewed: daysViewed)
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(bookmarkedArticles) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "bookmarks")
        } else {
            print("Failed to save people")
        }
    }
    
    @objc func load() {
        let defaults = UserDefaults.standard
        if let loadedBookmarks = defaults.object(forKey: "bookmarks") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                bookmarkedArticles = try jsonDecoder.decode([Article].self, from: loadedBookmarks)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Unable to load bookmarks")
            }
        }
    }
    
}


protocol PopupDelegate {
    func popupDidDisappear(articleType: ArticleType, daysViewed: DaysViewed)
}

protocol BookmarkDelegate {
    func toggleBookmark(newArticleID: Int)
}
