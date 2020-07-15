//
//  Stores.swift
//  RedStore
//
//  Created by yujinpil on 2020/05/12.
//  Copyright © 2020 jinpil. All rights reserved.
//

import Foundation

struct Stores: Decodable {
  let head: [Head]?
  let row: [Store]?
  
  init() {
    head = nil
    row = nil
  }
}
