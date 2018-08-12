//
//  Errors.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 09.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import Foundation

struct GeneralErrorResponse: Decodable {
	let errors: Array<GeneralError>
}

struct GeneralError: Error, Decodable {
	let name: String
	let message: String
}

struct ParsingErrors {
	static let wrongResponse = GeneralError(name: "Wrong response", message: "Wrong response type or empty data")
	static let decodeError = GeneralError(name: "Decode Error", message: "Sorry, error during decoding")
}

class ErrorsHandler {
	static func handleErrors(data: Data?, response: URLResponse?, error: Error?, successHandler: @escaping (_ data: Data) -> (), errorHandler: @escaping (_ error: Array<Error>) -> ()) {
		if let error = error {
			errorHandler([error])
		} else if let response = response as? HTTPURLResponse, let data = data, !data.isEmpty {
			if (response.statusCode / 100) == 2 {
				successHandler(data)
			} else {
				if let errorResponse = try? JSONDecoder().decode(GeneralErrorResponse.self, from: data) {
					errorHandler(errorResponse.errors)
				} else {
					errorHandler([ParsingErrors.decodeError])
				}
			}
		} else {
			errorHandler([ParsingErrors.wrongResponse])
		}
	}
}

struct DataResponse<DataType: Decodable>: Decodable {
	let success: Bool
	let data: DataType
}

class ResponseDecoder<Response: Decodable>: ErrorsHandler {
	static func decodeResponse(data: Data?, response: URLResponse?, error: Error?, successHandler: @escaping (_ result: Response) -> (), errorHandler: @escaping (_ error: Array<Error>) -> ()) {
		self.handleErrors(data: data, response: response, error: error, successHandler: { (data) in
			if let result = try? JSONDecoder().decode(Response.self, from: data) {
				successHandler(result)
			} else {
				errorHandler([ParsingErrors.decodeError])
			}
		}, errorHandler: errorHandler)
	}
}
