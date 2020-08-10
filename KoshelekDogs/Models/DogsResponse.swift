//
//  DogsResponse.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct DogsResponse: Codable {
    let message: [String: [String]]
    let status: String
}
