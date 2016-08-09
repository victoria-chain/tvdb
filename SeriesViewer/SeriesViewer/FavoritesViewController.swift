//
//  FavoritesViewController.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/7/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    var favoritedSeries = DBManager.sharedInstance.favorites()
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritedSeries?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let favoritedRepository = favoritedSeries?[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SeriesCell", forIndexPath: indexPath)
        //        cell.textLabel!.text = favoritedRepository?.name
//        cell.detailTextLabel!.text = favoritedRepository?.owner?.name
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let repoToDelete = favoritedSeries?[indexPath.row]
                else {
                    return
            }
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            DBManager.sharedInstance.removeFromFavorites(repoToDelete)
            tableView.endUpdates()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: show detail info
//        guard let
//            itemToDisplay = favoritedSeries?[indexPath.row],
//            url = NSURL(string: itemToDisplay.url)
//            else {
//                return
//        }
//        UIApplication.sharedApplication().openURL(url)
    }
    
}


