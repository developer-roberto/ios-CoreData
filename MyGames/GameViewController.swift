//
//  GameViewController.swift
//  MyGames
//
//  Created by Roberto Oliveira on 02/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    var game:Game!

    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    
    
    
    
    
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblTitle.text = self.game.title
        self.lblSubtitle.text = self.game.console?.title
        if let date = self.game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            self.lblDate.text = "Release Date: " + formatter.string(from: date)
        }
        if let image = self.game.cover as? UIImage {
            self.ivCover.image = image
        } else {
            self.ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = self.game
    }


}
