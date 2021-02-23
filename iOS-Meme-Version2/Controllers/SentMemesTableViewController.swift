//
//  SentMemesTableViewController.swift
//  iOS-Meme-Version2
//
//  Created by Anupam Beri on 20/02/2021.
//


import Foundation
import UIKit

// MARK: - The table representation of the Sent Memes
class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addMemeButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addMeme(_:)))
        self.navigationItem.rightBarButtonItem = addMemeButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func addMeme(_ sender: UIBarButtonItem) {
        let memeEditorViewController = self.storyboard?.instantiateViewController(identifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(memeEditorViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell") as! SentMemesTableViewCell
        let sentMeme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the imagem the top and the bottom text
        cell.memeImage.image = sentMeme.memedImage
        cell.summary.text = "\(sentMeme.topText)...\(sentMeme.bottomText)"
        
        return cell
    }
}
