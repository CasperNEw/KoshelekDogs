//
//  DogTableViewCell.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class DogTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak private var label: UILabel!

    // MARK: - Properties
    static let identifier = String(describing: DogTableViewCell.self)

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }

    // MARK: - Public function
    public func setupCell(name: String, subCount: Int, type: DataType) {

        let key = type == .all ? "subbreeds" : "photos"

        let mainAttr = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Light", size: 17)]
        let mainAttrString = NSMutableAttributedString(string: name.capitalized + "  ",
                                                       attributes: mainAttr as [NSAttributedString.Key: Any])

        if subCount > 0 {
            let subAttr = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Light", size: 10)]
            let subAttrString = NSMutableAttributedString(string: "(\(subCount) \(key))",
                                                          attributes: subAttr as [NSAttributedString.Key: Any])
            mainAttrString.append(subAttrString)
        }

        label.attributedText = mainAttrString
    }
}
