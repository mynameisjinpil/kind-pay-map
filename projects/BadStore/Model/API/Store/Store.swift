//
//  Store.swift
//  RedStore
//
//  Created by yujinpil on 2020/05/12.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Store: Decodable {
  let name: String?
  let industType: String?
  let oldAddress: String?
  let newAddress: String?
  let telNumber: String?
  let latitude: String?
  let longitude: String?
  let regionMoneyName: String?
  
  enum CodingKeys: String, CodingKey {
    case name = "CMPNM_NM"
    case industType = "INDUTYPE_NM"
    case oldAddress = "REFINE_LOTNO_ADDR"
    case newAddress = "REFINE_ROADNM_ADDR"
    case telNumber = "TELNO"
    case regionMoneyName = "REGION_MNY_NM"
    case latitude = "REFINE_WGS84_LAT"
    case longitude = "REFINE_WGS84_LOGT"
  }
}
