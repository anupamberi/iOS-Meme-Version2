//
//  MemeDetailViewController.swift
//  iOS-Meme-Version2
//
//  Created by Anupam Beri on 02/03/2021.
//

import Foundation
import UIKit

// MARK : This view controller displays the original meme with its aspect ratio
class MemeDetailViewController: UIViewController {
    
    var sentMeme: Meme!
    
    @IBOutlet weak var sentMemeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemeImageView.image = sentMeme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
