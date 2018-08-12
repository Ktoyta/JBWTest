//
//  SandboxManager.swift
//  JBWTest
//
//  Created by Konstantin Boichenko on 10.08.2018.
//  Copyright © 2018 Konstantin Boichenko. All rights reserved.
//

import Foundation

enum Locale: Int {
	case bg_BG = 0
	case da_DK
	case el_GR
	case sen_NGs
	case sen_ZAs
	case fi_FI
	case he_IL
	case ka_GE
	case me_ME
	case nl_NL
	case pt_PT
	case sr_Cyrl_RS
	case tr_TR
	case zh_TW
	case ar_JO
	case en_AU
	case en_NZ
	case es_AR
	case hr_HR
	case kk_KZ
	case ro_MD
	case sr_Latn_RS
	case uk_UA
	case ar_SA
	case bn_BD
	case de_AT
	case en_CA
	case en_PH
	case es_ES
	case fr_BE
	case is_IS
	case ko_KR
	case mn_MN
	case ro_RO
	case sr_RS
	case at_AT
	case de_CH
	case en_GB
	case en_SG
	case es_PE
	case fr_CA
	case hu_HU
	case it_CH
	case nb_NO
	case ru_RU
	case sv_SE
	case de_DE
	case en_HK
	case en_UG
	case es_VE
	case fr_CH
	case hy_AM
	case it_IT
	case lt_LT
	case ne_NP
	case pl_PL
	case sk_SK
	case vi_VN
	case cs_CZ
	case el_CY
	case en_IN
	case en_US
	case fa_IR
	case fr_FR
	case id_ID
	case ja_JP
	case lv_LV
	case nl_BE
	case pt_BR
	case sl_SI
	case th_TH
	case zh_CN
	
	static var count: Int {
		return Locale.zh_CN.rawValue + 1
	}
	
	var description: String {
		switch self {
			case .bg_BG: return "bg_BG"
			case .da_DK: return "da_DK"
			case .el_GR: return "el_GR"
			case .sen_NGs: return "en_NG"
			case .sen_ZAs: return "en_ZA"
			case .fi_FI: return "fi_FI"
			case .he_IL: return "he_IL"
			case .ka_GE: return "ka_GE"
			case .me_ME: return "me_ME"
			case .nl_NL: return "nl_NL"
			case .pt_PT: return "pt_PT"
			case .sr_Cyrl_RS: return "sr_Cyrl_RS"
			case .tr_TR: return "tr_TR"
			case .zh_TW: return "zh_TW"
			case .ar_JO: return "ar_JO"
			case .en_AU: return "en_AU"
			case .en_NZ: return "en_NZ"
			case .es_AR: return "es_AR"
			case .hr_HR: return "hr_HR"
			case .kk_KZ: return "kk_KZ"
			case .ro_MD: return "ro_MD"
			case .sr_Latn_RS: return "sr_Latn_RS"
			case .uk_UA: return "uk_UA"
			case .ar_SA: return "ar_SA"
			case .bn_BD: return "bn_BD"
			case .de_AT: return "de_AT"
			case .en_CA: return "en_CA"
			case .en_PH: return "en_PH"
			case .es_ES: return "es_ES"
			case .fr_BE: return "fr_BE"
			case .is_IS: return "is_IS"
			case .ko_KR: return "ko_KR"
			case .mn_MN: return "mn_MN"
			case .ro_RO: return "ro_RO"
			case .sr_RS: return "sr_RS"
			case .at_AT: return "at_AT"
			case .de_CH: return "de_CH"
			case .en_GB: return "en_GB"
			case .en_SG: return "en_SG"
			case .es_PE: return "es_PE"
			case .fr_CA: return "fr_CA"
			case .hu_HU: return "hu_HU"
			case .it_CH: return "it_CH"
			case .nb_NO: return "nb_NO"
			case .ru_RU: return "ru_RU"
			case .sv_SE: return "sv_SE"
			case .de_DE: return "de_DE"
			case .en_HK: return "en_HK"
			case .en_UG: return "en_UG"
			case .es_VE: return "es_VE"
			case .fr_CH: return "fr_CH"
			case .hy_AM: return "hy_AM"
			case .it_IT: return "it_IT"
			case .lt_LT: return "lt_LT"
			case .ne_NP: return "ne_NP"
			case .pl_PL: return "pl_PL"
			case .sk_SK: return "sk_SK"
			case .vi_VN: return "vi_VN"
			case .cs_CZ: return "cs_CZ"
			case .el_CY: return "el_CY"
			case .en_IN: return "en_IN"
			case .en_US: return "en_US"
			case .fa_IR: return "fa_IR"
			case .fr_FR: return "fr_FR"
			case .id_ID: return "id_ID"
			case .ja_JP: return "ja_JP"
			case .lv_LV: return "lv_LV"
			case .nl_BE: return "nl_BE"
			case .pt_BR: return "pt_BR"
			case .sl_SI: return "sl_SI"
			case .th_TH: return "th_TH"
			case .zh_CN: return "zh_CN"
		}
	}
}

enum SandboxEndPoint {
	case text(accessToken: String, locale: Locale)
	case person(accessToken: String, locale: Locale)
}

extension SandboxEndPoint: EndPoint {
	
	private struct BodyKeys {
		static let name = "name"
		static let email = "email"
		static let password = "password"
	}
	
	var bodyParameters: Parameters? {
		return nil
	}
	
	var getParameters: Parameters? {
		switch self {
			case .text(_, let locale), .person(_, let locale):
			return ["locale" : locale.description]
		}
	}
	
	var HTTPMethod: Method {
		return Method.get
	}
	
	var path: String {
		var path = "https://apiecho.cf/api/get/"
		switch self {
			case .text(_): path.append("text/")
			case .person(_): path.append("person/")
		}
		return path
	}
	
	var headers: Headers? {
		switch self {
			case .text(let accessToken, _), .person(let accessToken, _):
			return ["Authorization" : "Bearer \(accessToken)"]
		}
	}
	
}

struct Person: Decodable {
	let name: String
	let email: String
	let firstName: String
	let lastName: String
	let title: String
	let phoneNumber: String
	let timezone: String
	let country: String
	let city: String
	let address: String
	let latitude: Double
	let longitude: Double
	let ipAddress: String
	let bio: String
	
	private enum CodingKeys: String, CodingKey {
		case bio, longitude, latitude, address, city, country, timezone, title, email, name
		case phoneNumber = "phone_number"
		case lastName = "last_name"
		case firstName = "first_name"
		case ipAddress = "ip_address"
	}
}

class SandboxManager {
	var token: String
	private var requester = Requester()
	
	init(withToken token: String) {
		self.token = token
	}
	
	func getText(withLocale locale: Locale, completion: @escaping (String?, Array<Error>?) -> () ) {
		requester.request(endPoint: SandboxEndPoint.text(accessToken: token, locale: locale)) { (data, response, error) in
			ResponseDecoder<DataResponse<String>>.decodeResponse(data: data, response: response, error: error, successHandler: { textResponse in
				completion(textResponse.data, nil)
			}, errorHandler: { (errors) in
				completion(nil, errors)
			})
		}
	}
	
	func getPerson(withLocale locale: Locale, completion: @escaping (Person?, Array<Error>?) -> () ) {
		requester.request(endPoint: SandboxEndPoint.text(accessToken: token, locale: locale)) { (data, response, error) in
			ResponseDecoder<DataResponse<Person>>.decodeResponse(data: data, response: response, error: error, successHandler: { textResponse in
				completion(textResponse.data, nil)
			}, errorHandler: { (errors) in
				completion(nil, errors)
			})
		}
	}
}
