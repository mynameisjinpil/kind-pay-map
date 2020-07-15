//
//  Head.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/19.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Head: Decodable {
  let count: Int?
  
  enum CodingKeys: String, CodingKey {
    case count = "list_total_count"
  }
}
