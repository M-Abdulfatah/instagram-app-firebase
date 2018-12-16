//
//  CustomImageView.swift
//  Instgram
//
//  Created by ASUGARDS on 11/7/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {

  var lastUrlUsedToLoadImage: String?

  func loadImage(urlString: String) {
    lastUrlUsedToLoadImage = urlString

    self.image = nil

    if let cashedImage = imageCache[urlString] {
      self.image = cashedImage
      return
    }

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { (data, response, err) in
      if let err = err {
        print("faild to fetch photos", err.localizedDescription)
      }

      if url.absoluteString != self.lastUrlUsedToLoadImage {
        return
      }

      guard let imageData = data else { return }

      let photoImage = UIImage(data: imageData)

      imageCache[url.absoluteString] = photoImage

      DispatchQueue.main.async {
        self.image = photoImage
      }
      }.resume()
  }
}
