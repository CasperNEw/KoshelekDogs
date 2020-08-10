//
//  FavoriteRepository.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import CoreData

class FavoriteRepository {

    // MARK: - Property
    private let context: NSManagedObjectContext?

    // MARK: - Initialization
    init(context: NSManagedObjectContext?) {
        self.context = context
    }

    // MARK: - Public functions
    public func getAllFavorites(completion: @escaping (Result<[DogCoreData], Error>) -> Void) {

        guard let context = context else {
            completion(.failure(NSError(domain: "CoreData",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Cannot find entity"])))
            return
        }

        let fetchRequest: NSFetchRequest<DogCoreData> = DogCoreData.fetchRequest()

        do {
            completion(.success(try context.fetch(fetchRequest)))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    public func addToFavorite(breed: String,
                              url: String,
                              completion: @escaping (Result<DogCoreData, Error>) -> Void) {

        guard let context = context else {
            completion(.failure(NSError(domain: "CoreData",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Cannot find entity"])))
            return
        }

        var duplicte = false
        getFavorite(breed: breed) { result in

            switch result {
            case .success(let dogObject):
                if let dog = dogObject {
                    if var urls = dog.urls {
                        urls.append(url)
                        dog.urls = urls

                        do {
                            try self.context?.save()
                            completion(.success(dog))
                            duplicte = true
                        } catch let error as NSError {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }

        if duplicte { return }

        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: DogCoreData.self),
                                                      in: context) else {

                completion(.failure(NSError(domain: "CoreData",
                                            code: 404,
                                            userInfo: [NSLocalizedDescriptionKey: "Cannot find entity"])))
                return
        }

        let dogObject = DogCoreData(entity: entity, insertInto: context)

        dogObject.breed = breed
        dogObject.urls = [url]

        do {
            try context.save()
            completion(.success(dogObject))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    public func removeFromFavorite(breed: String,
                                   url: String,
                                   completion: @escaping (Result<DogCoreData, Error>) -> Void) {

        getFavorite(breed: breed) { result in

            switch result {
            case .success(let dogObject):

                guard let dog = dogObject else {
                    completion(
                        .failure(NSError(domain: "CoreData",
                                         code: 404,
                                         userInfo: [NSLocalizedDescriptionKey: "Cannot find entity"])))
                    return
                }
                if var urls = dog.urls {
                    urls.removeAll { $0 == url }

                    if urls.isEmpty {
                        self.removeData(dog) { completion($0) }
                        return
                    }

                    dog.urls = urls

                    do {
                        try self.context?.save()
                        completion(.success(dog))
                        return
                    } catch let error as NSError {
                        completion(.failure(error))
                        return
                    }
                }

            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }

    public func getFavorite(breed: String,
                            completion: @escaping (Result<DogCoreData?, Error>) -> Void) {

        let fetchRequest: NSFetchRequest<DogCoreData> = DogCoreData.fetchRequest()

        do {
            let data = try context?.fetch(fetchRequest).filter { $0.breed == breed }.first
            completion(.success(data))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    // MARK: - Module functions
    private func removeData(_ entity: DogCoreData,
                            completion: @escaping (Result<DogCoreData, Error>) -> Void) {

        context?.delete(entity)
        do {
            try context?.save()
            completion(.success(entity))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
