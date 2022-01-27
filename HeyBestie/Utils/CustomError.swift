//
//  CustomError.swift
//  HeyBestie
//
//  Created by Bernie Cartin on 9/14/21.
//

import Foundation

enum CustomError: Error {
    case invalidPassword

    case notFound

    case unexpected(code: Int)
}
