//
//  DataController.swift
//  Stique
//
//  Created by Nima Sepehr on 11/20/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import Foundation

enum Playlists: String {
    case MasterPlaylist = "masterPlaylist"
    case UserPlaylist   = "userPlaylist"
}


// Let's define an alias for the type of object we'll use everywhere
typealias StiqueData = [String: AnyObject]
typealias StiqueRating = [String: Int]


class DataController {
    
    let userDefaults = UserDefaults.standard
    let ratingsKey = "Ratings"


    func getMainViewData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = UserDefaults.standard
        do {
            let path = Bundle.main.path(forResource: "words", ofType: "json")
            let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: path!))
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: AnyObject]]
            if let jsonData = jsonData {
                tableData = jsonData
                if (userDefaults.bool(forKey: "sort")) {
                    tableData = tableData.reversed()
                }
                if userDefaults.bool(forKey: "watched") {
                    var NewTableData = [[String: AnyObject]]()
                    if let watched = userDefaults.object(forKey: "watched_words") as? [String] {
                        for row in tableData {
                            if watched.contains(row["word"] as! String) {
                                NewTableData += [row]
                            }
                        }
                    }
                    tableData = NewTableData
                }
            }
        } catch _ {
            // error handling
            print("error couldn't load the data for table at Data Controller class")
        }
        
        return tableData
    }
    
    func addToWatchedList(_ vocabulary: String) {
        var watched = [vocabulary]
        if let watched2 = userDefaults.object(forKey: "watched_words") as? [String] {
            watched += Array(Set(watched2)) // unique it
        }
        userDefaults.set(watched, forKey: "watched_words")
        userDefaults.synchronize()
    }
    
    func addToPlaylistData(_ data: [[String: AnyObject]]) {
        var tableData = data
        //let userDefaults = UserDefaults.standard
        do {
            if let playlist = userDefaults.string(forKey: Playlists.UserPlaylist.rawValue) {
                let jsonData = try JSONSerialization.jsonObject(with: playlist.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData += jsonData
                }
            }
            let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: Playlists.UserPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to add user playlist")
        }
    }
    
    func removePlaylistData(_ data: [[String: AnyObject]], index: Int) {
        var tableData: [[String: AnyObject]] = data
        let userDefaults = UserDefaults.standard
        do {
            tableData.remove(at: index)
            let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: Playlists.UserPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove playlist")
        }
    }
    
    func getPlaylistData() -> [[String: AnyObject]] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = UserDefaults.standard
        if let playlists = userDefaults.string(forKey: Playlists.UserPlaylist.rawValue) {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: playlists.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            } catch _ {
                // error handling
                print("Error... Unable to get User Playlist data")
            }
        }
        
        return tableData
    }
    
    func addToUserPlaylist(_ data: StiqueData, playlist: String) {
        var tableData: [StiqueData] = [data]
        var isUnique: Bool = true
        let playlistKey: String = getUserPlaylistKey(playlist)
        print("From data controller. Adding word \(data["word"]!) to playlist key " + playlistKey)
        do {
            let jsonData = getPlaylistDataForTitle(playlist)
            print("My jsonData for playlist is: ")
            print(jsonData)
            for item in jsonData {
                if item["word"] as! String == (data["word"] as! String) {
                    isUnique = false
                    break
                }
            }
            if (isUnique) {
                tableData += jsonData
                print("Inside the addToUserPlaylist and table data is: ")
                print(tableData)
                let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
                userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: playlistKey)
                userDefaults.synchronize()
            }
        } catch _ {
            print("Unable to add to user playlist")
        }
    }
    
    func getUserPlaylistKey(_ playlistName: String) -> String {
        let playlistKey: String = Playlists.UserPlaylist.rawValue + playlistName
        return playlistKey
    }
    
    func removePlaylistDataForTitle(_ data: [[String: AnyObject]], playlist: String, index: Int) -> [[String: AnyObject]] {
        let playlistKey = getUserPlaylistKey(playlist)
        var tableData = data
        let userDefaults = UserDefaults.standard
        do {
            tableData.remove(at: index)
            let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: playlistKey)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove data for playlist title \(playlistKey)")
        }
        
        return tableData
    }
    
    func getPlaylistDataForTitle(_ playlist: String) -> [StiqueData] {
        let playlistKey = getUserPlaylistKey(playlist)
        print("Getting playlist data for key: " + playlistKey)
        var tableData = [StiqueData]()
        do {
            if let _playlist = userDefaults.string(forKey: playlistKey) {
                let jsonData = try JSONSerialization.jsonObject(with: _playlist.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [StiqueData]
                print("jsonData for that key is: ")
                print(jsonData)
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            }
        } catch _ {
                // error handling
                print("Error... Unable to the playlist data for title: \(playlistKey)")
        }
        
        return tableData
    }
    
    func addToMasterPlaylistData(_ data: StiqueData) {
        
        var tableData = [data]
        do {
            if let playlist = userDefaults.string(forKey: Playlists.MasterPlaylist.rawValue) {
                let jsonData = try JSONSerialization.jsonObject(with: playlist.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [StiqueData]
                if let jsonData = jsonData {
                    for item in jsonData {
                        if item["word"] as! String == (data["word"] as! String) {
                            tableData = []
                            break
                        }
                    }
                    tableData += jsonData
                }
            }
            let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: Playlists.MasterPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Unable to add to master playlist")
        }
    }
    
    func removeMasterPlaylistData(_ data: [StiqueData]?, index: Int) -> [StiqueData] {
        let userDefaults = UserDefaults.standard
        var tableData = [StiqueData]()
        if data == nil {
            tableData = getMasterPlaylistData()
        } else {
            tableData = data!
        }
        do {
            tableData.remove(at: index)
            let jsonData2 = try JSONSerialization.data(withJSONObject: tableData, options: JSONSerialization.WritingOptions.prettyPrinted)
            userDefaults.set(NSString(data: jsonData2, encoding: String.Encoding.ascii.rawValue), forKey: Playlists.MasterPlaylist.rawValue)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to remove master playlist detail data")
        }
        
        return tableData
    }
    
    func getMasterPlaylistData() -> [StiqueData] {
        var tableData = [[String: AnyObject]]()
        let userDefaults = UserDefaults.standard
        if let playlist = userDefaults.string(forKey: Playlists.MasterPlaylist.rawValue) {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: playlist.data(using: String.Encoding.utf8)!, options: .allowFragments) as? [[String: AnyObject]]
                if let jsonData = jsonData {
                    tableData = jsonData
                }
            } catch _ {
                // error handling
                print("Error... Failed to get Master Playlist data")
            }
        }
        
        return tableData
    }
    
    func getRatings() -> StiqueRating {
        var ratings : StiqueRating = [:]
        if let ratingData = userDefaults.string(forKey: ratingsKey) {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: ratingData.data(using: String.Encoding.utf8)!, options: .allowFragments) as? StiqueRating
                if let jsonData = jsonData {
                    ratings = jsonData
                }
            } catch _ {
                // Error handling
                print("Error... Failed to get ratings data")
            }
        }
        
        return ratings
    }
    
    func updateRatings(_ ratings: StiqueRating) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ratings, options: .prettyPrinted)
            userDefaults.set(NSString(data: jsonData, encoding: String.Encoding.ascii.rawValue), forKey: ratingsKey)
            userDefaults.synchronize()
        } catch _ {
            print("Failed to update ratings data")
        }
    }
    
    func updateWebRatings(_ vocabulary: String, rating: Int) {
        // Update the web database for the rating
        let id = userDefaults.integer(forKey: AppDefaultKeys.ID.rawValue)
        print("id from user defaults is \(id)")
        let baseURLString = "https://7t48nu4m33.execute-api.us-west-1.amazonaws.com/Development/testingPythonRDS"
        let postString = "{\"APIKey\": \"NayaTooBaba\", \"GUID\": \"\(id)\", \"Vocabulary\": \"\(vocabulary)\", \"Rating\": \"\(rating)\"}"
        let url = URL(string: baseURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("My returned data from web is: ")
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with request")
            }
        }
        task.resume()
    }
}
