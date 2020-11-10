//
//  NavigationController.swift
//  JTTD
//
//  Created by Jason Hoffman on 11/9/20.
//  Copyright © 2020 Jason Hoffman. All rights reserved.
//

import Foundation
import UIKit

class GameNavigationController: UINavigationController {
    
    class MyNavigationController: UINavigationController {
        
        override func segueForUnwinding(to toViewController: UIViewController,
                                        from fromViewController: UIViewController,
                                                        identifier: String?) -> UIStoryboardSegue {
            return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        }
    }
    
}
