//
//  MemesCollectionTabViewController.swift
//  MemeMe
//
//  Created by Benny on 10/17/15.
//  Copyright © 2015 Benny Rodriguez. All rights reserved.
//

import UIKit

class MemesCollectionTabViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = (UIApplication.shared.delegate as? AppDelegate)?.memes
        
        tabBarController!.tabBar.isHidden = false
        
        configureFlowLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMemeDetailViewFromCollection" {
            
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
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        collectionView.isHidden = true
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        configureFlowLayout()
    }
    
    fileprivate func configureFlowLayout() {
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
}

// MARK: UICollectionViewDelegate
extension MemesCollectionTabViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showMemeDetailViewFromCollection", sender: indexPath.row)
    }
}

// MARK: UICollectionViewDataSource
extension MemesCollectionTabViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell

        cell.configureWithInfo(memes[indexPath.row])
        
        return cell
    }
    
}
