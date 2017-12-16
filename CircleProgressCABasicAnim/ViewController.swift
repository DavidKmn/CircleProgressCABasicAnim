//
//  ViewController.swift
//  CircleProgressCABasicAnim
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        
         let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupNotificationObservers()
        
        setupCircleLayer()
        
        setupPercentageLabel()

    }
    
    fileprivate func setupCircleLayer() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: UIColor.clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: UIColor.trackStrokeColor, fillColor: UIColor.backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: UIColor.outlineStrokeColor, fillColor: UIColor.clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    @objc private func handleTap() {
        
        beginDownloadingFile()
        
        //        animateCircle()
        
    }
    
    let urlString = "https://cdn.gratisography.com/photos/412H.jpg"
    
    private func beginDownloadingFile() {
        
        print("Attmepting to download file")
        shapeLayer.strokeEnd = 0
        
        let config = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    

}








