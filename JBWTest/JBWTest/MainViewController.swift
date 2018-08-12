//
//  ViewController.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 09.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
	
	private let manager = NetworkManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewControllers?.forEach({ viewController in
			if let viewController = viewController as? LoginViewController {
				viewController.manager = self.manager
			} else if let viewController = viewController as? SignUpViewController {
				viewController.manager = self.manager
			}
		})
	}
}




