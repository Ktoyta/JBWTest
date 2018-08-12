//
//  SignUpViewController.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 10.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
	
	weak var manager: NetworkManager?
	@IBOutlet weak var errorLabel: UILabel?
	@IBOutlet weak var passwordField: UITextField?
	@IBOutlet weak var emailField: UITextField?
	@IBOutlet weak var nameField: UITextField?
	
	@IBAction func signUp(_ sender: UIButton) {
		sender.isEnabled = false
		guard let manager = self.manager else {
			return
		}
		
		manager.authManager.signup(withName: nameField?.text ?? "", email: emailField?.text ?? "", password: passwordField?.text ?? "", completion: { [weak self] (success, errors) in
			DispatchQueue.main.async {
				guard let `self` = self else {
					return
				}
				
				sender.isEnabled = true
				self.errorLabel?.text = ""
				if success {
					self.performSegue(withIdentifier: "forward", sender: self)
				} else if let errors = errors {
					for error in errors {
						if let error = error as? GeneralError {
							self.errorLabel?.text?.append("\(error.name) : \(error.message) \n")
						} else {
							self.errorLabel?.text?.append(error.localizedDescription)
						}
					}
				}
			}
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? TextViewController {
			destination.manager = self.manager
		}
	}
	
}
