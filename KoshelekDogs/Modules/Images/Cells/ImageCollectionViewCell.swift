//
//  ImageCollectionViewCell.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func favoriteButtonTapped(image: Image)
}

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!

    // MARK: - Properties
    static let identifier = String(describing: ImageCollectionViewCell.self)
    weak var delegate: ImageCollectionViewCellDelegate?
    private var currentImage: Image?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public functions
    public func setupCell(image: Image) {
        currentImage = image
        imageView.image = UIImage(data: image.data)
        likeButton.setImage(UIImage(systemName: image.isFavorite ? "heart.fill" : "heart" ), for: .normal)
        likeButton.tintColor = image.isFavorite ? .red : .lightGray
    }

    // MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let image = currentImage else { return }
        delegate?.favoriteButtonTapped(image: image)
    }
}
