//
//  ViewController.swift
//  MyTheadTry
//
//  Created by wangxiangbo on 2019/11/21.
//  Copyright © 2019 CICTEC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var image4: UIImageView!
    
    
    let imageUrls = [
        "http://pic1.win4000.com/pic/d/e7/5a2a3d5a18.jpg",
        "http://pic1.win4000.com/pic/d/e7/1c100c63d3.jpg",
        "http://pic1.win4000.com/pic/d/e7/815cbfc698.jpg",
        "http://pic1.win4000.com/pic/d/e7/37f6510c46.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let queue = OperationQueue()
    
    @IBAction func downloadImages(_ sender: UIButton) {
        
        print("下载开始位置")
        customserial()
//        concurrenrQueue()
//        OperationQueueDownload()
        print("下载结束位置")
    }
    
    
    @IBAction func clearDownload(_ sender: UIButton) {
        self.image1.image = nil
        self.image2.image = nil
        self.image3.image = nil
        self.image4.image = nil
        URLCache.shared.removeAllCachedResponses()
    }
    /// 取消所有的下载： 已经完成的就没有效果。
    @IBAction func cancleDownload(_ sender: UIButton) {
        queue.cancelAllOperations()
    }
    

}

extension ViewController{
    /// 自定义串行队列
    func customserial()  {
        // Create serial queue  /// 默认串行
        let serialQueue1 = DispatchQueue(label: "images")
        
        // Add task
        serialQueue1.async(execute: {
            let img1 = Downloader.downloadImageWithURL(url: self.imageUrls[0])
            DispatchQueue.main.async {
                self.image1.image = img1
                self.image1.clipsToBounds = true
            }
            
            let img3 = Downloader.downloadImageWithURL(url: self.imageUrls[2])
            DispatchQueue.main.async {
                self.image3.image = img3
                self.image3.clipsToBounds = true
            }
            
        })
        let serialQueue2 = DispatchQueue(label: "images1")
        
        serialQueue2.async(execute: {
            let img2 = Downloader.downloadImageWithURL(url: self.imageUrls[1])
            DispatchQueue.main.async {
                self.image2.image = img2
                self.image2.clipsToBounds = true
            }
            
            let img4 = Downloader.downloadImageWithURL(url: self.imageUrls[3])
            DispatchQueue.main.async {
                self.image4.image = img4
                self.image4.clipsToBounds = true
            }
        })
    }
    
    /// concurrenrQueue 中
    func concurrenrQueue() {
        let currQueue = DispatchQueue.global(qos: .default)
        // dispatch_async
        currQueue.async(execute: {
            let img1 = Downloader.downloadImageWithURL(url: self.imageUrls[0])
            DispatchQueue.main.async {
                self.image1.image = img1
                self.image1.clipsToBounds = true
            }
        })
        
        currQueue.async(execute: {
            let img2 = Downloader.downloadImageWithURL(url: self.imageUrls[1])
            DispatchQueue.main.async {
                self.image2.image = img2
                self.image2.clipsToBounds = true
            }
        })
        
        currQueue.async(execute: {
            let img3 = Downloader.downloadImageWithURL(url: self.imageUrls[2])
            DispatchQueue.main.async {
                self.image3.image = img3
                self.image3.clipsToBounds = true
            }
        })
        
        currQueue.async(execute: {
            let img4 = Downloader.downloadImageWithURL(url: self.imageUrls[3])
            DispatchQueue.main.async {
                self.image4.image = img4
                self.image4.clipsToBounds = true
            }
        })
    }
    /// OperationQueue
    func OperationQueueDownload() {
        queue.addOperation({
            let img1 = Downloader.downloadImageWithURL(url: self.imageUrls[0])
            
            OperationQueue.main.addOperation({
                self.image1.image = img1
                self.image1.clipsToBounds = true
            })
        })
        
        let op2 = BlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(url: self.imageUrls[1])
            
            OperationQueue.main.addOperation({
                self.image2.image = img2
                self.image2.clipsToBounds = true
            })
        })
        op2.completionBlock = { print("image2 downloaded") }
        
        let op3 = BlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(url: self.imageUrls[2])
            
            OperationQueue.main.addOperation({
                self.image3.image = img3
                self.image3.clipsToBounds = true
            })
        })
        op3.completionBlock = { print("image3 downloaded") }
        
        let op4 = BlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(url: self.imageUrls[3])
            
            OperationQueue.main.addOperation({
                self.image4.image = img4
                self.image4.clipsToBounds = true
            })
        })
        op4.completionBlock = { print("image4 downloaded") }
        
        op3.addDependency(op4)
        op2.addDependency(op3)
        
        queue.addOperation(op4)
        queue.addOperation(op3)
        queue.addOperation(op2)
    }
    
}

/// 来自boxue 11的手笔
class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
        do {
            let data = try Data(contentsOf: URL(string: url)!)
            return UIImage(data: data)
        } catch  {
            return UIImage()
        }
    }
}
