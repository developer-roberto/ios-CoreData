//
//  UIViewController + CoreData.swift
//  MyGames
//
//  Created by Roberto Oliveira on 03/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
