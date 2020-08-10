//
//  Image.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct Image {

    let breed: String
    let url: String
    let data: Data
    var isFavorite: Bool
}

extension Image: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
