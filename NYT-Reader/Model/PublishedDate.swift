//
//  PublishedDate.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/17/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import Foundation


func convertDateType(published_Date: String) -> String? {
    let dateComponents = published_Date.components(separatedBy: "-")
    let year = dateComponents[0]
    let day = dateComponents[2]
    let month = Int(dateComponents[1]) ?? 0

    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let formattedMonth = months[month - 1].uppercased()
    let formattedDateString = "\(day) \(formattedMonth) \(year)"
    
    return formattedDateString
}
