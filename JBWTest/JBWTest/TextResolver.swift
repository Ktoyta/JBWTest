//
//  TextResolver.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 12.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import Foundation

class TextResolver {
	
	static func calculateSymbols(inText text: String) -> Array<(Character, Int)>? {
		var result: Dictionary<Character, Int> = [:]
		
		guard !text.isEmpty else {
			return nil
		}
		
		for character in text {
			result[character] = (result[character] ?? 0) + 1
		}
		
		return result.map({
			return ($0.key, $0.value)
		})
	}
	
}
