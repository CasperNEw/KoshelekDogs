//
//  ImageResponse.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct ImageResponse: Codable {
    let message: [String]
    let status: String
}
