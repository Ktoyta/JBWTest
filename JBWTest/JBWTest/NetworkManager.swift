//
//  NetworkManager.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 12.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import Foundation

class NetworkManager {
	
	lazy var authManager: AuthManager = {
		let authManager = AuthManager()
		authManager.delegate = self
		return authManager
	}()
	
	var sandboxManager: SandboxManager?
	
}

extension NetworkManager: AuthManagerDelegate {
	
	func authManagerDidLogin(_ manager: AuthManager) {
		if let token = manager.user?.accessToken {
			self.sandboxManager = SandboxManager(withToken: token)
		}
	}
	
	func authManagerDidSignup(_ manager: AuthManager) {
		if let token = manager.user?.accessToken {
			self.sandboxManager = SandboxManager(withToken: token)
		}
	}
	
	func authManagerDidLogout(_ manager: AuthManager) {
		self.sandboxManager = nil
	}
	
}
