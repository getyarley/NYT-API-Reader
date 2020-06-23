//
//  URLCreator.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/16/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import Foundation

enum ArticleType: String {
    case shared = "shared"
    case viewed = "viewed"
    case emailed = "emailed"
}

enum DaysViewed: String {
    case one = "1"
    case seven = "7"
    case thirty = "30"
}

class DataLoader {
    
    static func buildURLFromType(articleType: ArticleType, daysViewed: DaysViewed) -> String {
        let urlRoot = "https://api.nytimes.com/svc/mostpopular/v2/"
        let myKey = ".json?api-key=CjtyVGMUguR6nEVONdDSYVSGNk6rP9uU"
        let builtURL = urlRoot + articleType.rawValue + "/" + daysViewed.rawValue + myKey
        return builtURL
    }
    
    
    
    static func LoadURLData(articleType: ArticleType, daysViewed: DaysViewed, success: @escaping (_ data: Data?) -> Void) {
        let urlString = buildURLFromType(articleType: articleType, daysViewed: daysViewed)
        
        guard let url = URL(string: urlString) else {
            print("URL is not valid")
            success(nil)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url) {
                success(data)
            } else {
                print("Unable to get data")
                success(nil)
            }
        }
        
        
    } //END OF FUNC
    
    
    
}
