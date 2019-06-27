//
//  AppleItemController.swift
//  AppleSearch
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class AppleItemController {
    
    //PROPERTIES
    static let sharedInstance = AppleItemController()
    static let baseURL = URL(string: "https://itunes.apple.com")
    
    //RETRIEVE ITEMS
    static func fetchAppleItem(searchTermEntered: String, completion: @escaping ([AppleItem]?) -> Void ) {
        
        //BUILD FULL URL FOR FETCHING A SEARCH RESULT
        guard var url = baseURL else { completion(nil); return } //unwrap base url
        url.appendPathComponent("search") //add search term (/search)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true) //add components to url
        let searchTermQuery = URLQueryItem(name: "term", value: searchTermEntered) //(?term=searchTermEntered)
        let mediaQuery = URLQueryItem(name: "media", value: "music")//(&media=music)
        components?.queryItems = [searchTermQuery, mediaQuery]
        
        //baseURL+search+?searchTermQuery+&mediaQuery
        //https://itunes.apple.com/search?term=searchTermEntered&media=music
        
        guard let finalURL = components?.url else { completion(nil); return }

        //RETRIEVE DATA
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Uh Oh! Search Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            
            //DECODE DATA
            do {
                let decoder = JSONDecoder()
                let topLevelJson = try decoder.decode(ResultsJson.self, from: data)
                completion(topLevelJson.results) //complete with an [AppleItem] (specified in fun parameters)
            } catch {
                print("Uh Oh! Decoding Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
        } .resume() //resume after calling URLSession (put on closing brace)
    }
    
    //RETRIEVE ITEM IMAGES
    static func fetchImageFor(appleItem: AppleItem, completion: @escaping (UIImage?) -> Void) {
        
        let imageURL = appleItem.imageURL
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("Oh No! Image Search Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("Oh No! Data wasn't fetched correctly")
                completion(nil)
                return
            }
            let itemImage = UIImage(data: data)
            completion(itemImage)
        }.resume()
    }
}
