//
//  APIRequest.swift
//  BadStore
//
//  Created by 유진필 on 2020/07/13.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public enum RequestType: String {
  case GET, POST
}

protocol APIRequest {
  var headers : HTTPHeaders { get }
  var method : RequestType { get }
  var path : String { get }
  var paprameters : [String : String] { get }
}

extension APIRequest {
  func request(url : URL) -> URLRequest {
    guard var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
      fatalError("Unable to create URL...")
    }
    
    components.queryItems = paprameters.map {
      URLQueryItem(name: String($0), value: String($1))
    }
    
    guard let url = components.url else {
      fatalError("Could not get url")
    }
    
    let request : URLRequest = {
      var request = URLRequest(url: url)
      request.headers = headers
      request.httpMethod = method.rawValue
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      return request
    }()
    
    return request
  }
}
