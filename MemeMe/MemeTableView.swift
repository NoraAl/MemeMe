//
//  MemeTableView.swift
//  MemeMe
//
//  Created by Nora on 12/25/15.
//  Copyright © 2015 Nora. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        tableView.backgroundColor = myBackgroundColor
        if let loadedMemes = loadMemess(){
            allMemes = loadedMemes
        } else {
            allMemes = [Memes]()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MemeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableCell
        
        let memeObject = allMemes[indexPath.row]
        
        cell.cellImageView.image = memeObject.memedImage
        cell.cellTopText.text = memeObject.top
        cell.cellBottomText.text = memeObject.bottom
        cell.cellDateText.text = memeObject.time
        
        return cell
    }
    
    // MARK: Deleting Memes
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            allMemes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController  = storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetail
        memeDetailViewController.memeDetail = allMemes[indexPath.row]
        
        navigationController!.pushViewController(memeDetailViewController, animated: true)

    }
    
    @IBAction func unwindToMemeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MemeEditorViewController, meme = sourceViewController.newMeme {
            let newIndexPath = NSIndexPath(forRow: allMemes.count, inSection: 0)
            allMemes.append(meme)
            saveAllMemes()
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
            
        }
    }
}