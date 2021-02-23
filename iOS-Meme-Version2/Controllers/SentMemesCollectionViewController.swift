//
//  SentMemesCollectionViewController.swift
//  iOS-Meme-Version2
//
//  Created by Anupam Beri on 21/02/2021.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    // MARK: Properties
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addMemeButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMeme(_:)))
        self.navigationItem.rightBarButtonItem = addMemeButton
    }
    
    @objc func addMeme(_ sender: UIBarButtonItem) {
        let memeEditorViewController = self.storyboard?.instantiateViewController(identifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(memeEditorViewController, animated: true, completion: nil)
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image
        cell.sentMemeImageView?.image = meme.memedImage
        
        return cell
    }
}
