# NYT-API-Reader

> Fetch JSON data from the NY Times API, parse, and view on iphones supporting iOS 13 or later. Includes the ability to sort by multiple criteria and bookmark articles that are saved in User Defaults to be loaded upon relaunch. 


### Preview
<p align="center">
  <img src ="https://github.com/getyarley/getyarley-images/blob/master/NYT-Reader_ex.GIF?raw=true"/>
</p>


Welcome to my NY Times API Reader! This project uses the free NY Times API to read JSON files and display them in a simple format on your iOS device. The user has the ability to view the title, date, and abstract for several articles. Loaded articles can be filtered based on several categories (Most Viewed, Most Shared, Most Emailed) and recent time periods (Last 24 Hours, Last 3 Days, Last 30 Days).

The purpose of building this app was for learning/practicing purposes only. Feel free to fix any bugs, include additional features, or use this as a framework for your project! That being said, make sure to get your own API key for free at the NY Times developer website and follow the instructions below to replace my key with yours. (Each key has a limited amount of calls allowed.)


_Disclaimer: This is NOT meant for production, and could possibly provoke legal action from the NY Times if you attempt to make a profit off of the data provided by their free API. Let's not take advantage of companies like the NY Times for giving us wonderful free API's like this._




## NY Times API Developer Setup

Visit the NY Times Developer portal to create your free API key: [developer.nytimes.com](https://developer.nytimes.com/)

_Get Started link:  [developer.nytimes.com/get-started](https://developer.nytimes.com/get-started)_

- Once you get your own API key from the website above, follow the steps below to add it to your project.


## Update API Key
1. Go to [DataLoader.swift](https://github.com/getyarley/NYT-API-Reader/blob/master/NYT-Reader/Model/DataLoader.swift)

2. Update myKey with your new API key: My-API-Key

Change:
```sh
let myKey = ".json?api-key=CjtyVGMUguR6nEVONdDSYVSGNk6rP9uU"
```
To: 
```sh
let myKey = ".json?api-key=My-API-Key"
```




