//
//  NetworkService.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

class NetworkService {

    // MARK: - Properties
    enum DogCeoPath: String {
        case list = "/api/breeds/list/all"
        case image = "/api/breed/%@/images"
    }

    // MARK: - Public functions
    public func getDogsList(completion: @escaping (Result<[Dog], Error>) -> Void) {

        let path = DogCeoPath.list.rawValue
        var dogs: [Dog] = []

        request(path: path) { (result: Result<DogsResponse, Error>) in

            switch result {
            case .success(let data):

                data.message.forEach { (key, value) in
                    dogs.append(Dog(breed: key, subBreed: value))
                }
                completion(.success(dogs))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getImages(dog: (breed: String, subBreed: String),
                          completion: @escaping (Result<[Image], Error>) -> Void) {

        if dog.breed.isEmpty {
            completion(.failure(NetworkError.requestError))
            return
        }

        let component: String = dog.subBreed.isEmpty ? dog.breed : dog.breed + "/\(dog.subBreed)"
        let path = String(format: DogCeoPath.image.rawValue, component)
        var images: [Image] = []
        let group = DispatchGroup()
        var lastError: Error?

        request(path: path) { (result: Result<ImageResponse, Error>) in

            switch result {
            case .success(let response):

                response.message.forEach { urlString in
                    group.enter()
                    self.getImageData(with: urlString) { result in

                        switch result {
                        case .success(let data):
                            images.append(Image(breed: dog.subBreed.isEmpty ? dog.breed : dog.subBreed,
                                                url: urlString,
                                                data: data,
                                                isFavorite: false))
                        case .failure(let error):
                            lastError = error
                        }
                        group.leave()
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }

            group.notify(queue: .main) {

                if images.isEmpty {
                    guard let error = lastError else { return }
                    completion(.failure(error))
                    return
                }
                completion(.success(images))
            }
        }
    }

    public func getImageData(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.requestError))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(NetworkError.incorrectDataError))
                    return
                }
                completion(.success(data))
            }
        }
        task.resume()
    }

    // MARK: - Module function
    private func request<T: Decodable>(path: String,
                                       completion: @escaping (Result<T, Error>) -> Void) {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "dog.ceo"
        component.path = path

        guard let url = component.url else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.serverError(error: error)))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noConnectionError))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.incorrectDataError))
                }
            }
        }
        task.resume()
    }
}
