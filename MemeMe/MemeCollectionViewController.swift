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
    var heightToWidthtRatio :CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        
        collectionView!.backgroundColor = myBackgroundColor
        heightToWidthtRatio = view.frame.height / view.frame.width
        
        let space: CGFloat = 2.0
        let numberOfCells = 3
        
        let cellWidth = (self.view.frame.size.width-((CGFloat(numberOfCells)-1) * space))/CGFloat (numberOfCells)
        let cellHeight = cellWidth * heightToWidthtRatio
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    
    // MARK: Handling orientation change
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        switch UIDevice.currentDevice().orientation{
        case .Portrait, .PortraitUpsideDown:
            heightToWidthtRatio = view.frame.height/view.frame.width
        case .LandscapeLeft,  .LandscapeRight:
            heightToWidthtRatio = view.frame.height/view.frame.width
        default:
            heightToWidthtRatio = view.frame.height/view.frame.width
        }
        
        collectionView?.reloadData()
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionToMemeEditor"{
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
}
