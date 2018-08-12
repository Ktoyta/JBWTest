//
//  TextViewController.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 12.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import UIKit

class CharacterCountCell: UITableViewCell {
	
	@IBOutlet weak var characterLabel: UILabel?
	@IBOutlet weak var countLabel: UILabel?
	
}

class TextViewController: UIViewController {
	
	weak var manager: NetworkManager?
	var array: Array<(Character, Int)>?
	var locale = Locale.bg_BG
	@IBOutlet weak var textLabel: UILabel?
	@IBOutlet weak var tableView: UITableView?
	
	@IBOutlet weak var pickerView: UIPickerView?
	
	@IBAction func getText(_ sender: UIButton) {
		guard let sandboxManager = self.manager?.sandboxManager else {
			return
		}
		sender.isEnabled = false
		sandboxManager.getText(withLocale: locale) { [weak self] (text, errors) in
			DispatchQueue.main.async {
				guard let `self` = self else {
					return
				}
				
				sender.isEnabled = true
				if let text = text {
					self.array = TextResolver.calculateSymbols(inText: text)
					self.tableView?.reloadData()
				} else if let errors = errors {
					for error in errors {
						if let error = error as? GeneralError {
							self.textLabel?.text?.append("\(error.name) : \(error.message) \n")
						} else {
							self.textLabel?.text?.append(error.localizedDescription)
						}
					}
				}
			}
		}
	}
}

extension TextViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.array?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCountCell", for: indexPath)
		if let cell = cell as? CharacterCountCell {
			let (character, count) = self.array?[indexPath.row] ?? (" ", 0)
			
			cell.characterLabel?.text = "\"\(character)\""
			cell.countLabel?.text = "times: \(count)"
		}
		return cell
	}

}

extension TextViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return Locale.count
	}
	
}

extension TextViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Locale(rawValue: row)?.description
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.locale = Locale(rawValue: row) ?? .bg_BG
	}
	
}
