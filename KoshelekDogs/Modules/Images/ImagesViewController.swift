//
//  ImagesViewController.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Props
    var viewModel: ImagesViewModelProtocol?

    private var images: [Image] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
        setupCollectionView()
        setupNavigationBar()
        bindViewModel()
        viewModel?.loadData()
    }

    // MARK: - Module functions
    private func setupActivityIndicator() {

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }

    private func setupCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }

        collectionView.register(UINib(nibName: ImageCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    private func setupNavigationBar() {

        let backButton = UIBarButtonItem(title: "< Back",
                                         style: UIBarButtonItem.Style.plain, target: self,
                                         action: #selector(goBack))

        var image = UIImage(systemName: "tray.and.arrow.up")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(share))

        navigationItem.leftBarButtonItem = backButton
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)]
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any],
                                                                 for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    private func bindViewModel() {

        viewModel?.loadDataCompletion = { [weak self] result in

            switch result {
            case .success((let title, let images)):
                self?.title = title.capitalized
                self?.images = images
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
            self?.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Actions
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func share() {
        showShareAction(with: "Share Photo", and: "")
    }
}

// MARK: - Setup functions
extension ImagesViewController: UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                 for: indexPath) as? ImageCollectionViewCell

        cell?.setupCell(image: images[indexPath.item])
        cell?.delegate = self
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width,
                      height: view.safeAreaLayoutGuide.layoutFrame.height)
    }
}

// MARK: - ImageCollectionViewCellDelegate
extension ImagesViewController: ImageCollectionViewCellDelegate {

    func favoriteButtonTapped(image: Image) {
        viewModel?.changeFavorite(image: image)
    }
}
