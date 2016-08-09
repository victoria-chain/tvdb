//
//  SeriesViewController.swift
//  SeriesViewer
//
//  Created by Victoria Denisyuk on 8/7/16.
//  Copyright © 2016 Victoria Denisyuk. All rights reserved.
//

import UIKit
import SDWebImage

class SeriesViewController: UIViewController {
    
    // MARK: - Properties
    private var downloader = Downloader()
    private let onError = {
        print("ohh error")
        //TODO: show try again alert, showSeries() on "retry"
    }
    
    private var series: [Series]?

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        showSeries()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func showSeries(){
        downloader.authenticate(onError) { [unowned self] in
            print("logged in")
            self.downloader.loadSeries(self.onError) { series in
                self.series = series
                self.collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension SeriesViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let seriesToShow = series?[indexPath.row]
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SeriesCell", forIndexPath: indexPath) as? SeriesCell
        else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel!.text = String(seriesToShow?.id) //TODO
        //        cell.detailTextLabel!.text = favoritedRepository?.owner?.name
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension SeriesViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let seriesToShow = series?[indexPath.row]
        guard let
            seriesId = seriesToShow?.id
        else {
            return
        }
        
        let onError = {
            print("load failed")
        }
        
        downloader.loadSeriesInfo(seriesId, onInfoError: onError ) { info in
            guard let
                infoCell = cell as? SeriesCell
            else {
                return
            }
            infoCell.titleLabel!.text = info?.seriesName
            let imageURL =  NSURL(string: self.downloader.imagePathForSeries(seriesId))
            infoCell.imageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "ic_tv"))
        }
    }
    
}
