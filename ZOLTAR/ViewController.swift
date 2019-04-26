//
//  ViewController.swift
//  Gradient
//
//  Created by Александр Македон on 4/9/19.
//  Copyright © 2019 Алек Мак. All rights reserved.
//

import UIKit

var track1 = "Смоки Мо - Было и было (minus)"


class ViewController: CustomViewController {

    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var giftImageView: UIImageView!
    
    @IBAction func getValue(_ sender: UIDatePicker) {
        
        print(sender.date)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(track1)
    }

    
    

}
// эта часть кода задумывалась как такова, что получает обработанное число с дата пиккера и с помощью функции фищитывает какой знак зодиака- проблема 1) нет понимания какие данные подходят для работы функуии, 2) как работает эта штука//
enum Zodiac: String {
    case aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces
}

extension Zodiac {
    var dateRangeString: String {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        let from = df.string(from: dateRange.lowerBound)
        let to = df.string(from: dateRange.upperBound)
        return "\(from) - \(to)"
    }
    
    var dateRange: ClosedRange<Date> {
        var foo: ((Int, Int), (Int, Int)) {
            switch self {
            case .aries:
                return ((3, 21), (4, 19))
            case .taurus:
                return ((4, 20), (5, 20))
            case .gemini:
                return ((5, 21), (6, 20))
            case .cancer:
                return ((6, 21), (7, 22))
            case .leo:
                return ((7, 23), (8, 22))
            case .virgo:
                return ((8, 23), (9, 22))
            case .libra:
                return ((9, 23), (10, 22))
            case .scorpio:
                return ((10, 23), (11, 21))
            case .sagittarius:
                return ((11, 22), (12, 21))
            case .capricorn:
                return ((12, 22), (1, 19))
            case .aquarius:
                return ((1, 20), (2, 18))
            case .pisces:
                return ((2, 19), (3, 20))
            }
        }
        
        let now = Date()
        var cc1 = Calendar.current.dateComponents(in: .current, from: now)
        var cc2 = cc1
        
        cc1.month = foo.0.0
        cc1.day = foo.0.1
        cc2.month = foo.1.0
        cc2.day = foo.1.1
        
        if self == .capricorn {
            if now >= cc1.date! {
                cc2.year! += 1
                cc2.yearForWeekOfYear = nil  // or CRASH!
            } else {
                cc1.year! -= 1
                cc1.yearForWeekOfYear = nil
            }
        }
        
        return cc1.date!...cc2.date!
    }
    
    static var today: Zodiac {
        let today = Date()
        let all = [Zodiac.aries, .taurus, .gemini, .cancer, .leo, .virgo, .libra, .scorpio, .sagittarius, .capricorn, .aquarius, .pisces]
        for sign in all {
            if sign.dateRange.contains(today) {
                return sign
            }
        }
        return .taurus  // only possible if there's a bug in our code
    }
}
//эта штука должна была включить gif, но что-то пошло не так//
/*
 import ImageIO
extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
*/

