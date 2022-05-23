//
//  NetworkService.swift
//  FollowersGitHubiOS
//
//  Created by Thiago de Oliveira Santos on 23/05/22.
//

import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    let cache = NSCache<NSString, UIImage>()
}
