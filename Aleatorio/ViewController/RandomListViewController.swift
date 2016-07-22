//
//  RandomListViewController.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/19/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import UIKit

class RandomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
//------------------------------
//MARK: Storyboard connections
//------------------------------
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var randomizeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
//------------------------------
//MARK: Properties
//------------------------------
    var items: [String] = ["Frango à Parmegiana", "BK", "Zaitune", "Dioguinho", "Costelo", "Beco", "Conexão", "Toledo"]
    var selectedIndex: Int!
    
    
//------------------------------
//MARK: - Lifecycle
//------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = -1
        
        self.randomizeButton.layer.cornerRadius = 8.0
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


//------------------------------
//MARK: Buttons actions
//------------------------------
    
    @IBAction func randomizeSelection(sender: UIButton) {
        
        let itemsAmount = UInt32(self.items.count)
        let random = Int(arc4random_uniform(itemsAmount))
        
        self.resultLabel.text = items[random]
        
        
        let indexPath = NSIndexPath(forRow: random, inSection: 0)
        
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
    }
    
    
//------------------------------
//MARK: Tableview
//------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font = UIFont(name: "Kannada Sangam MN", size: 14)
        cell.textLabel?.text = self.items[indexPath.row]
//        cell.selectionStyle  = .None
        return cell
     }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
//------------------------------
//MARK: Navigation
//------------------------------
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
