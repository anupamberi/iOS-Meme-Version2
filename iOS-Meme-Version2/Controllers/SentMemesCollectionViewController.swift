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
    
    private let sectionInsets = UIEdgeInsets(
      top: 0.0,
      left: 10.0,
      bottom: 0.0,
      right: 10.0)
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
        // Subscribe to notification for reloading data
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe to notification for reloading data
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addMemeButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMeme(_:)))
        self.navigationItem.rightBarButtonItem = addMemeButton
    }
    
    @objc func refresh(notification: NSNotification) {
        self.collectionView.reloadData()
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
        // Set the image, top and bottom labels
        //cell.sentMemeImageView.image = meme.memedImage.crop(image: meme.memedImage)
        cell.sentMemeImageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        
        let sentMeme = self.memes[(indexPath as NSIndexPath).row]
        memeDetailViewController.sentMeme = sentMeme
        
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}

extension UIImage {
    func crop(image: UIImage) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if (contextSize.width > contextSize.height) {
            posY = 0
            posX = ((contextSize.width - contextSize.height) / 2)
            newWidth = contextSize.height
            newHeight = contextSize.height
        } else {
            posY = ((contextSize.height - contextSize.width) / 2)
            posX = 0
            newWidth = contextSize.width
            newHeight = contextSize.width
        }
        
        let croppingRectangle: CGRect = CGRect(x: posX, y: posY, width: newWidth, height: newHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = (contextImage.cgImage?.cropping(to: croppingRectangle))!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return croppedImage
    }
}

extension SentMemesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
