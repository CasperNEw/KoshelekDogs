//
//  String+.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

extension String {

    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last ?? ""
    }
}
