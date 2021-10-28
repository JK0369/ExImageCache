//
//  ImageCache.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/28.
//

import Foundation
import UIKit

/// ImageCache에서 사용하는 모델은 Item을 준수하는 모델을 사용하도록 강제하기 위해 선언
public protocol Item {
    var image: UIImage? { get set }
    var imageUrl: URL { get }
    var identifier: String { get }
}

public class ImageCache {
    public static let shared = ImageCache()
    private init() {}

    private let cachedImages = NSCache<NSURL, UIImage>()
    private var waitingRespoinseClosure = [NSURL: [(Item, UIImage) -> Void]]()

    private final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }

    final func load(url: NSURL, item: Item, completion: @escaping (Item, UIImage?) -> Void) {
        // Cache에 저장된 이미지가 있는 경우
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }

        // Cache에 저장된 이미지가 없는 경우, 서버로 부터 데이터를 가져오고나서 데이터를 completion에 넘겨주어야 하기때문에 기록
        if waitingRespoinseClosure[url] != nil {
            /// 이미 같은 url에 대해서 처리중인 경우
            waitingRespoinseClosure[url]?.append(completion)
            return
        } else {
            /// 해당 url처리가 처음인 경우 > URLSession으로 data 획득 필요
            waitingRespoinseClosure[url] = [completion]
        }

        // .epemeral: 따로 NSCache를 사용하기 때문에 URLSession에서 cache를 사용하지 않게끔 설정
        let urlSession = URLSession(configuration: .ephemeral)
        let task = urlSession.dataTask(with: url as URL) { data, response, error in
            // 이미지 data 획득
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.waitingRespoinseClosure[url], error == nil else {
                      DispatchQueue.main.async {
                          completion(item, nil)
                      }
                      return
                  }

            // 캐시에 저장 후 completion에 전달
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            for block in blocks {
                DispatchQueue.main.async {
                    block(item, image)
                }
            }
            return
        }

        task.resume()
    }
}
