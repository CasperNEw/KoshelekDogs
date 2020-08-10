//
//  UILabel+.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UILabel {

    func setSelect(_ isSelected: Bool) {
        self.font = UIFont(name: isSelected ? "Noteworthy-Bold" : "Noteworthy-Light", size: 10)
        self.textColor = isSelected ? .darkGray : .lightGray
    }
}
