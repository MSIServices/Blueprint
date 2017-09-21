//
//  ErrorHandler.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

enum ServerError: String {
    case internalServerError = "Internal Server Error"
    case resourceNotFound = "Resource not found"
    case parsingFailure = "Parsing Failure"
    case noData = "No Data"
    case methodError = "Method Error"
    case failedAttempt = "Failed Attempt"
    case unknownError = "Unknown Error"
    case badRequest = "Bad Request"
    case forbidden = "Forbidden"
    case serviceUnavailable = "Service Unavailable"
    case gatewayTimeout = "Gateway Timeout"
    case badGateway = "Bad Gateway"
    case unauthorized = "Unauthorized"
}
