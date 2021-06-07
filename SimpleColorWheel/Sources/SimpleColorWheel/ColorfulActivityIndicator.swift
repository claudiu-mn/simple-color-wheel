//
//  ColorfulActivityIndicator.swift
//
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import UIKit

public class ColorfulActivityIndicator: UIView {
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        let spokeCount = 12
        
        for i in 0..<spokeCount {
            let spoke = UIView()
            spoke.isUserInteractionEnabled = false
            spoke.translatesAutoresizingMaskIntoConstraints = false
            spoke.backgroundColor = UIColor(hue: CGFloat(i) / CGFloat(spokeCount),
                                            saturation: 1,
                                            brightness: 1,
                                            alpha: 1)
            addSubview(spoke)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.width == 0 || bounds.height == 0 { return }
        
        let count = subviews.count
        
        let minDim = min(bounds.width, bounds.height)
        let spaceProportion: CGFloat = 0.5
        let spaceRadius = spaceProportion * minDim / 2
        
        let spokeLength = minDim * (1 - spaceProportion) / 2
        let spokeWidth = spokeLength * 0.4
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        for i in 0..<count {
            let spoke = subviews[i]
            spoke.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: spokeWidth,
                                  height: spokeLength)
            let angleMult: CGFloat = CGFloat(i) / CGFloat(count)
            let angle = angleMult * (.pi * 2)
            spoke.center =
                center.pointOnCircleAt(radius: spaceRadius + spokeLength / 2,
                                       angle: angle)
            spoke.transform = CGAffineTransform(rotationAngle: angle - .pi / 2)
            spoke.layer.cornerRadius = spokeWidth / 2
        }
        
        startTime = CACurrentMediaTime()
        tick()
    }
    
    public func start() {
        if displayLink == nil {
            startTime = CACurrentMediaTime()
            displayLink = CADisplayLink(target: self,
                                        selector: #selector(tick))
            displayLink!.add(to: .main, forMode: .common)
        }
    }
    
    public func stop() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink = nil
        
        for spoke in subviews {
            spoke.alpha = 0
        }
    }
    
    @objc private func tick() {
        let fullRotationInterval: TimeInterval = 1
        
        let currentTime = CACurrentMediaTime()
        let difference = currentTime - startTime
        
        for i in 0..<subviews.count {
            let adjustedDiff = difference + Double(i) / Double(subviews.count) * fullRotationInterval
            var remainder = adjustedDiff.truncatingRemainder(dividingBy: fullRotationInterval)
            remainder /= fullRotationInterval
            
            // Weird index, but gives clockwise.
            // Change to plain i for counter-clockwise
            let spoke = subviews[subviews.count - 1 - i]
            spoke.alpha = (1 - CGFloat(remainder)).clamped(to: 0.5...1)
        }
    }
    
    deinit {
        stop()
    }
}
