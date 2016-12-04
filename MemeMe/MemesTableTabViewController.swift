//
//  MemesTableTabViewController.swift
//  MemeMe
//
//  Created by Benny on 10/17/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import UIKit

class MemesTableTabViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = (UIApplication.shared.delegate as? AppDelegate)?.memes
        
        tabBarController!.tabBar.isHidden = false
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMemeDetailViewFromTable" {
            
            if let row = sender as? Int {
                
                let detailViewController = segue.destination as! MemeDetailViewController
                
                detailViewController.meme = memes[row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: UITextFieldDelegate
extension MemesTableTabViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showMemeDetailViewFromTable", sender: indexPath.row)
    }
}

// MARK: UITableViewDataSource
extension MemesTableTabViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        
        cell.configureWithInfo(memes[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            memes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
}
