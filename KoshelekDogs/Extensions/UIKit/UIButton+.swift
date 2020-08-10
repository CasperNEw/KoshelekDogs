//
//  UIButton+.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIButton {

    func setSelect(_ isSelected: Bool) {
        self.tintColor = isSelected ? .darkGray : .lightGray
    }
}
