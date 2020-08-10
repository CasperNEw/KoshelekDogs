//
//  NetworkError.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestError
    case incorrectDataError
    case noConnectionError
    case serverError(error: Error)
}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .requestError:
            return "Request formation error"
        case .incorrectDataError:
            return "Incorrect data received from the server"
        case .noConnectionError:
            return "No connection to the server"
        case .serverError(let error):
            return "Server error - \(error.localizedDescription)"
        }
    }
}
