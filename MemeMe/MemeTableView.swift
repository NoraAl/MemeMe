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
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        allMemes = loadMemess()!
        
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MemeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableCell
        
        let memeObject = allMemes[indexPath.row]
        
        cell.cellTopText.text = memeObject.top
        cell.cellBottomText.text = memeObject.bottom
        cell.imageView?.image = memeObject.memedImage
        
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

    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        print("unwind")
        if let sourceViewController = sender.sourceViewController as? MemeEditorViewController, meme = sourceViewController.newMeme {
            let newIndexPath = NSIndexPath(forRow: allMemes.count, inSection: 0)
            allMemes.append(meme)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            
            // Save the meals.
            saveAllMemes()
        }
    }
}



