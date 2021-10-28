//
//  ItunesAPI.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/28.
//

import Foundation

class ItunesAPI {
    static func fetchImages(completion: @escaping (Result<ItunesImageModel, Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=flappy&entity=software") else { return }
        let task = URLSession.shared.downloadTask(with: url) { url, response, error in
            do {
                if let url = url {
                    if let data = try? Data(contentsOf: url) {
                        let jsonDecoder = JSONDecoder()
                        let itunesImages = try jsonDecoder.decode(ItunesImageModel.self, from: data)
                        completion(.success(itunesImages))
                    }
                } else {
                    completion(.failure(error ?? NetworkError.unknown))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
