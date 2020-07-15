//
//  ReverseGeocoding.swift
//  BadStore
//
//  Created by 유진필 on 2020/07/13.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class ReverseGeocoding {
  let idHeader = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: "sb10h4g44n")
  let keyHeader = HTTPHeader(name: "X-NCP-APIGW-API-KEY",
                             value: "Czs7ZzPQHmgvPg0Y2cfMQEjxNg2WgOUB9LgS2uno")
  
  let url : URL? = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "naveropenapi.apigw.ntruss.com"
    components.path = "/map-reversegeocode/v2/gc"
    components.queryItems = [
      URLQueryItem(name: "request", value: "coordsToaddr"),
      URLQueryItem(name: "coords", value: "\(0.1234), \(0.5678)"),
      URLQueryItem(name: "sourcecrs", value: "epsg:4326"),
      URLQueryItem(name: "output", value: "json"),
      URLQueryItem(name: "orders", value: "admcode, addr"),
    ]
    return components.url
  }()
  
  private func get<T>() {
    
  }
}

