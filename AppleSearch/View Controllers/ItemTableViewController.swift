//
//  ItemTableViewController.swift
//  AppleSearch
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {

    //OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    
    //SOURCE OF TRUTH
    var appleItems: [AppleItem] = []
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        AppleItemController.fetchAppleItem(searchTermEntered: "Lindsey Stirling") { (appleItemsFromCompletion) in
            if let unwrappedAppleItems = appleItemsFromCompletion {
                self.appleItems = unwrappedAppleItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // TABLE VIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell else { return UITableViewCell() }

        let appleItem = appleItems[indexPath.row] //get search result items from the source of truth
        
        cell.itemSongName.text = appleItem.songName //update cell labels and image
        cell.itemArtistName.text = appleItem.artistName
        cell.itemAlbumName.text = appleItem.albumName
        AppleItemController.fetchImageFor(appleItem: appleItem) { (image) in //fetchImage function goes to background thread
            DispatchQueue.main.async { //put update image on main thread
                cell.itemImage.image = image
            }
        }
        return cell
    }
}

//DELEGATE
extension ItemTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm != "" else { return }
        
        AppleItemController.fetchAppleItem(searchTermEntered: searchTerm) { (appleItemsFromCompletion) in
            if let unwrappedAppleItems = appleItemsFromCompletion {
                self.appleItems = unwrappedAppleItems
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
