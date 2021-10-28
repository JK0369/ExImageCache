//
//  ItunesImageModel.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/29.
//

import Foundation

struct ItunesImageModel: Decodable {
    let resultCount: Int
    let results: [Result]

    struct Result: Codable {
        let screenshotUrls: [String]
    }
}
