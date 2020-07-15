//
//  Status.swift
//  BadStore
//
//  Created by yujinpil on 2020/05/20.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Status: Decodable {
  var code: Int
  var name: String
  var message: String
}
