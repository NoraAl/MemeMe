//
//  MemeTabViewController.swift
//  MemeMe
//
//  Created by Nora on 12/26/15.
//  Copyright © 2015 Nora. All rights reserved.
//


import UIKit

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = editButtonItem()
        
        collectionView!.backgroundColor = myBackgroundColor
        
        let heightToWidthtRatio = view.frame.height / view.frame.width
        let space: CGFloat = 2.0
        let numberOfCells = 3
        
        let cellWidth = (self.view.frame.size.width-((CGFloat(numberOfCells)-1) * space))/CGFloat (numberOfCells)
        let cellHeight = cellWidth * heightToWidthtRatio
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "MemeCollectionCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        let memeObject = allMemes[indexPath.row]
        cell.imageView.image = memeObject.memedImage
        
        return cell
    }
    
    // MARK: Navigaiton
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeDetailViewController  = storyboard.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetail
        memeDetailViewController.memeDetail = allMemes[indexPath.row]
        
        navigationController!.pushViewController(memeDetailViewController, animated: true)
        
    }
    
}
