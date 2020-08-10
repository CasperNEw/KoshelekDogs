//
//  SubBreedViewController.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol SubBreedViewControllerDelegate: AnyObject {
    func didSelect(breed: String, subBreed: String)
}

class SubBreedViewController: UIViewController {

    // MARK: - Properties
    private lazy var tableView: UITableView = {

        let tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: DogTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: DogTableViewCell.identifier)
        return tableView
    }()

    private var dog: Dog
    weak var delegate: SubBreedViewControllerDelegate?

    // MARK: - Initialization
    init(dog: Dog) {
        self.dog = dog
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
    }

    // MARK: - Module functions
    private func setupNavigationBar() {

        title = dog.breed.capitalized
        let backButton = UIBarButtonItem(title: "< Back",
                                         style: UIBarButtonItem.Style.plain, target: self,
                                         action: #selector(goBack))

        navigationItem.leftBarButtonItem = backButton
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)]
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes as [NSAttributedString.Key: Any],
                                                                 for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    // MARK: - Actions
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView
extension SubBreedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dog.subBreed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: DogTableViewCell.identifier,
                                 for: indexPath) as? DogTableViewCell

        cell?.setupCell(name: dog.subBreed[indexPath.row], subCount: 0, type: .all)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(breed: dog.breed, subBreed: dog.subBreed[indexPath.row])
    }
}
