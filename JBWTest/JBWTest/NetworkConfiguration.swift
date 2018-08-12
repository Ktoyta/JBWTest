//
//  NetworkConfiguration.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 09.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import UIKit

typealias Parameters = [String : Any]
typealias Headers = [String : String]

enum Method: String {
	case get = "GET"
	case post = "POST"
}

protocol EndPoint {
	var path: String { get }
	var HTTPMethod: Method { get }
	var headers: Headers? { get }
	var bodyParameters: Parameters? { get }
	var getParameters: Parameters? {get}
}

extension URLRequest {
	
	init?(endPoint: EndPoint) {
		
		guard let url = URL(string: endPoint.path) else {
			return nil
		}
		
		self.init(url: url)
		self.httpMethod = endPoint.HTTPMethod.rawValue
		
		if let getParameters = endPoint.getParameters {
			
			let queryItems = getParameters.map {
				return URLQueryItem(name: $0.key, value: $0.value as? String)
			}
			var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
			components?.queryItems = queryItems
			self.url = components?.url
			self.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
			
		}
		
		
		if var bodyParameters = endPoint.bodyParameters {
			
			for (key, value) in bodyParameters {
				if let dataValue = value as? Data {
					bodyParameters[key] = dataValue.base64EncodedString()
				}
			}
			
			if let encodedJSON = try? JSONSerialization.data(withJSONObject: bodyParameters) {
				self.httpBody = encodedJSON
				
				self.setValue("application/json", forHTTPHeaderField: "Accept")
				self.setValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		}
		
		if let headers = endPoint.headers {
			for (key, value) in headers {
				self.setValue(value, forHTTPHeaderField: key)
			}
		}
	}
	
}

class Requester {
	func request(endPoint: EndPoint, with completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
		if let request = URLRequest(endPoint: endPoint) {
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				completionHandler(data, response, error)
			}.resume()
		}
	}
}
