//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Roberto Oliveira on 02/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    
    
    
    // MARK: - Methods
    func updateContent(item:Game) {
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.console?.title
        if let image = item.cover as? UIImage {
            self.ivCover.image = image
        } else {
            self.ivCover.image = UIImage(named: "noCover")
        }
    }

}
