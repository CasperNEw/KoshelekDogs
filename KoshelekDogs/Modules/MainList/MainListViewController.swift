//
//  MainListViewController.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

enum DataType {
    case all
    case favorites
}

class MainListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var listButtonLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteButtonLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    var viewModel: MainListViewModel?
    var router: MainListRouterInput?

    private var dogs: [Dog] = [] {
        didSet {
            currentType = .all
        }
    }
    private var favorites: [FavoriteDog] = [] {
        didSet {
            currentType = .favorites
        }
    }
    private var currentType: DataType = .all {
        didSet {

            setupBottomButton()
            tableView.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModel()
        viewModel?.loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if currentType == .favorites {
            viewModel?.changeMode(mode: .favorite())
        }
    }

    // MARK: - Module functions
    private func bindViewModel() {

        viewModel?.loadDataCompletion = { [weak self] result in

            switch result {
            case .success(let dataType):
                switch dataType {
                case .all(let dogs):
                    self?.dogs = dogs
                case .favorite(let favorites):
                    self?.favorites = favorites
                }
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                self?.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }

    private func setupView() {

        title = "Breeds"

        setupBottomButton()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: DogTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: DogTableViewCell.identifier)
    }

    private func setupBottomButton() {
        let select = currentType == .all ? true : false
        listButton.setSelect(select)
        listButtonLabel.setSelect(select)
        favoriteButton.setSelect(!select)
        favoriteButtonLabel.setSelect(!select)
    }

    // MARK: - Actions
    @IBAction func bottomButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        let listIsSelected = sender == listButton ? true : false
        viewModel?.changeMode(mode: listIsSelected ? .all() : .favorite())
    }
}

// MARK: - TableView
extension MainListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentType == .all ? dogs.count : favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch currentType {
        case .all:
            let cell = tableView
                .dequeueReusableCell(withIdentifier: DogTableViewCell.identifier,
                                     for: indexPath) as? DogTableViewCell

            cell?.setupCell(name: dogs[indexPath.row].breed,
                            subCount: dogs[indexPath.row].subBreed.count,
                            type: .all)
            return cell ?? UITableViewCell()

        case .favorites:
        let cell = tableView
            .dequeueReusableCell(withIdentifier: DogTableViewCell.identifier,
                                 for: indexPath) as? DogTableViewCell

        cell?.setupCell(name: favorites[indexPath.row].breed,
                        subCount: favorites[indexPath.row].urls.count,
                        type: .favorites)
        return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch currentType {
        case .all:
            dogs[indexPath.row].subBreed.isEmpty ?
                router?.pushImagesViewController(breed: dogs[indexPath.row].breed, subBreed: "") :
                router?.pushSubBreedViewController(with: dogs[indexPath.row])
        case .favorites:
            router?.pushImagesViewController(favoriteDog: favorites[indexPath.row])
        }
    }
}

// MARK: - SubBreedViewControllerDelegate
extension MainListViewController: SubBreedViewControllerDelegate {

    func didSelect(breed: String, subBreed: String) {
        router?.pushImagesViewController(breed: breed, subBreed: subBreed)
    }
}
