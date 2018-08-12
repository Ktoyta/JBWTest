//
//  AuthManager.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 09.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import Foundation

private enum AuthEndPoint {
	case login(email: String, password: String)
	case signup(name: String, email: String, password: String)
	case logout(accessToken: String)
}

extension AuthEndPoint: EndPoint {
	
	private struct BodyKeys {
		static let name = "name"
		static let email = "email"
		static let password = "password"
	}
	
	var bodyParameters: Parameters? {
		switch self {
			case .login(let email, let password):
				return [BodyKeys.email : email, BodyKeys.password : password]
			case .signup(let name, let email, let password):
				return [BodyKeys.name : name, BodyKeys.email : email, BodyKeys.password : password]
			default: return nil
		}
	}
	
	var getParameters: Parameters? {
		return nil
	}
	
	var HTTPMethod: Method {
		return Method.post
	}
	
	var path: String {
		var path = "https://apiecho.cf/api/"
		switch self {
		case .login(_): path.append("login/")
		case .signup(_): path.append("signup/")
		case .logout(_): path.append("logout/")
		}
		return path
	}
	
	var headers: Headers? {
		switch self {
		case .logout(let accessToken):
			return ["Authorization" : "Bearer \(accessToken)"]
		default: return nil;
		}
	}
	
}

struct User: Decodable {
	let uid: Int
	let name: String
	let email: String
	let accessToken: String
	let role: Int
	let status: Int
	let created: Int
	let updated: Int
	
	private enum CodingKeys: String, CodingKey {
		case uid, name, email, role, status
		case accessToken = "access_token"
		case created = "created_at"
		case updated = "updated_at"
	}
}

protocol AuthManagerDelegate: class {
	
	func authManagerDidLogin(_ manager: AuthManager);
	func authManagerDidSignup(_ manager: AuthManager);
	func authManagerDidLogout(_ manager: AuthManager);
	
}

class AuthManager {
	
	weak var delegate: AuthManagerDelegate?
	private let requester = Requester()
	var user: User?
	
	func login(withEmail email: String, password: String, completion: @escaping (_ success: Bool, _ errors: Array<Error>?) -> ()) {
		requester.request(endPoint: AuthEndPoint.login(email: email, password: password)) { (data, response, error) in
			ResponseDecoder<DataResponse<User>>.decodeResponse(data: data, response: response, error: error, successHandler: { [weak self] userResponse in
				
				guard let `self` = self else {
					return
				}
				
				self.user = userResponse.data
				completion(true, nil)
				self.delegate?.authManagerDidLogin(self)
			}, errorHandler: { (errors) in
				completion(false, errors)
			})
		}
	}
	
	func signup(withName name: String, email: String, password: String, completion: @escaping (_ success: Bool, _ errors: Array<Error>?) -> ()) {
		requester.request(endPoint: AuthEndPoint.signup(name: name, email: email, password: password)) { (data, response, error) in
			ResponseDecoder<DataResponse<User>>.decodeResponse(data: data, response: response, error: error, successHandler: { [weak self] userResponse in
				
				guard let `self` = self else {
					return
				}
				
				self.user = userResponse.data
				completion(true, nil)
				self.delegate?.authManagerDidSignup(self)
			}, errorHandler: { (errors) in
				completion(false, errors)
			})
		}
	}
	
	func logout(completion: @escaping (_ success: Bool, _ errors: Array<Error>?) -> ()) {
		if let accessToken = user?.accessToken {
			requester.request(endPoint: AuthEndPoint.logout(accessToken: accessToken)) { (data, response, error) in
				ErrorsHandler.handleErrors(data: data, response: response, error: error, successHandler: { [weak self] (data) in
					
					guard let `self` = self else {
						return
					}
					
					completion(true, nil)
					self.delegate?.authManagerDidLogout(self)
				}, errorHandler: { (errors) in
					completion(false, errors)
				})
			}
		}
	}
}
