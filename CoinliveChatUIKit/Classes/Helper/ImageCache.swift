/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Image cache.
*/

import UIKit
import Foundation

// https://developer.apple.com/documentation/uikit/views_and_controls/table_views/asynchronously_loading_images_into_table_and_collection_views
class ImageCache {
    public static let shared = ImageCache()
    private init() {}

    private let cachedImages = NSCache<NSURL, UIImage>()
    private var waitingRespoinseClosure = [NSURL: [(UIImage) -> Void]]()

    private final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    final func clearAll() {
        self.cachedImages.removeAllObjects()
        self.waitingRespoinseClosure.removeAll()
    }

    final func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        // Cache에 저장된 이미지가 있는 경우
        if let cachedImage = image(url: url) {
                completion(cachedImage)
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
        let task = urlSession.dataTask(with: url as URL) { [weak self] data, response, error in
            // 이미지 data 획득
            guard let self = self else { return }
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.waitingRespoinseClosure[url], error == nil else {
                          completion(nil)
                      return
                  }

            // 캐시에 저장 후 completion에 전달
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            for block in blocks {
                // block? 
                block(image)
            }
            return
        }

        task.resume()
    }
}
