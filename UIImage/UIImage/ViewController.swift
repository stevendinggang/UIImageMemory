//
//  ViewController.swift
//  UIImage
//
//  Created by Steven on 2021/6/30.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


    }

    @IBAction func loadImage(_ sender: Any) {
        
        let filePath = Bundle.main.url(forResource: "image", withExtension: "JPG")

        if let filepathURL = filePath
        {
            let downsampledLadyImage = downsample(imageAt: filepathURL, to: image.bounds.size)
            image.image = downsampledLadyImage
        }

    }

    func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }

        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale

        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }


}

extension URL {
    /// 获取本地图片（asset）中的URL
    static func fromLocalImage(named name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).JPG")
        let path = url.path

        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.jpegData(compressionQuality: 1)
            else { return nil }
            /// 通过写入图片数据实现 路径url
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }
        return url
    }
}
