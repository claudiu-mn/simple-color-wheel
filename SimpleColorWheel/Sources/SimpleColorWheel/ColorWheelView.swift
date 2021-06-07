//
//  ColorWheelView.swift
//
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import UIKit

public protocol ColorWheelViewDelegate: AnyObject {
    func didStartSelection(in colorWheel: ColorWheelView,
                           with color: UIColor)
    func didChangeSelection(in colorWheel: ColorWheelView,
                            with color: UIColor)
    func didEndSelection(in colorWheel: ColorWheelView,
                         with color: UIColor)
}

public class ColorWheelView: UIView {
    public weak var delegate: ColorWheelViewDelegate?
    
    private weak var imageView: UIImageView!
    private weak var loading: ColorfulActivityIndicator!
    
    private var queue = DispatchQueue(label: "mn.claudiu.SimpleColorWheel",
                                      qos: .userInteractive)
    
    private var isLoading = false
    private var selecting = false
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        backgroundColor = .clear

        let loading = ColorfulActivityIndicator()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.isUserInteractionEnabled = false
        addSubview(loading)
        
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = false
        addSubview(imgView)
        
        self.loading = loading
        self.imageView = imgView
    }
    
    func loadColorWheel() {
        if isLoading || imageView.image != nil {
            return
        }
        
        isLoading = true
        
        loading.alpha = 1
        loading.start()
        imageView.alpha = 0
        
        let bounds = UIScreen.main.bounds
        
        let scale = UIScreen.main.scale
        let minDimScaled = min(scale * bounds.width, scale * bounds.height)
        
        let width = minDimScaled
        let height = minDimScaled

        let center = CGPoint(x: width / 2, y: height / 2)
        
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let intW = Int(width)
            let intH = Int(height)
            
            var bitmap = Bitmap(width: intW, height: intH, color: .white)
            
            for x in 0..<bitmap.width {
                for y in 0..<bitmap.height {
                    let point = CGPoint(x: x, y: y)
                    let rad = self.radius(for: point,
                                          from: center) / (minDimScaled / 2)
                    let ang = self.angle(for: point, from: center)
                    bitmap[x, y] = self.color(at: rad, ang)
                }
            }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(bitmap: bitmap)
                
                self.isLoading = false
                
                let duration = 0.25
                
                UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState]) {
                    self.loading.alpha = 0
                } completion: { success in
                    self.loading.stop()
                }
                
                UIView.animate(withDuration: duration, delay: duration, options: [.beginFromCurrentState]) {
                    self.imageView.alpha = 1
                }
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let minDim = min(bounds.width, bounds.height)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = minDim / 2
        imageView.bounds = CGRect(x: 0, y: 0, width: minDim, height: minDim)
        imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let loadingProportion: CGFloat = 0.5
        
        loading.bounds = CGRect(x: 0,
                                y: 0,
                                width: minDim * loadingProportion,
                                height: minDim * loadingProportion)
        loading.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        loadColorWheel()
    }
    
    private func radius(from touch: UITouch) -> CGFloat {
        let point = touch.location(in: self)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        return radius(for: point, from: center)
    }
    
    private func radius(for point: CGPoint, from center: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2))
    }
    
    private func angle(for point: CGPoint, from center: CGPoint) -> CGFloat {
        var angle = atan2(point.y - center.y, point.x - center.x)
        if angle < 0 { angle += 2 * CGFloat.pi }
        return angle
    }
    
    private func color(at radius: CGFloat, _ angle: CGFloat) -> Color {
        let bw = 1 - radius.clamped(to: 0...1)

        // From white to black
        let step1: CGFloat = 0.25

        // From black to color to white
        let step2: CGFloat = 0.625

        if bw < step1 {
            let value = 1 - (bw / step1).clamped(to: 0...1)
            return Color(r: UInt8(value * 255),
                         g: UInt8(value * 255),
                         b: UInt8(value * 255))
        }

        let hue = angle / (2 * .pi)

        let uiColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        let rC = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let gC = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let bC = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        uiColor.getRed(rC, green: gC, blue: bC, alpha: nil)

        let color = Color(r: UInt8(rC.pointee * 255),
                          g: UInt8(gC.pointee * 255),
                          b: UInt8(bC.pointee * 255))

        rC.deallocate()
        gC.deallocate()
        bC.deallocate()

        let lowerMult =
            ((bw.clamped(to: step1...step2) - step1) / (step2 - step1)).clamped(to: 0...1)
        let upperMult =
            ((bw.clamped(to: step2...1) - step2) / (1 - step2)).clamped(to: 0...1)

        let red =
            lowerMult * CGFloat(color.r) +
            upperMult * (255 - CGFloat(color.r))

        let green =
            lowerMult * CGFloat(color.g) +
            upperMult * (255 - CGFloat(color.g))

        let blue =
            lowerMult * CGFloat(color.b) +
            upperMult * (255 - CGFloat(color.b))

        return Color(r: UInt8(red), g: UInt8(green), b: UInt8(blue))
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            super.touchesBegan(touches, with: event)
            return
        }
        
        let minDim = min(bounds.width / 2, bounds.height / 2)
        
        if radius(from: touch) > minDim {
            super.touchesBegan(touches, with: event)
            return
        }
        
        selecting = true
        
        let col = color(from: touch)
        delegate?.didStartSelection(in: self, with: col)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard selecting == true else {
            super.touchesMoved(touches, with: event)
            return
        }
        guard let touch = touches.first else {
            super.touchesMoved(touches, with: event)
            return
        }
        
        let col = color(from: touch)
        delegate?.didChangeSelection(in: self, with: col)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard selecting == true else {
            super.touchesEnded(touches, with: event)
            return
        }
        guard let touch = touches.first else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        selecting = false
        
        let col = color(from: touch)
        delegate?.didEndSelection(in: self, with: col)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard selecting == true else {
            super.touchesCancelled(touches, with: event)
            return
        }
        guard let touch = touches.first else {
            super.touchesCancelled(touches, with: event)
            return
        }
        
        selecting = false
        
        let col = color(from: touch)
        delegate?.didEndSelection(in: self, with: col)
    }
    
    private func color(from touch: UITouch) -> UIColor {
        let point = touch.location(in: self)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let minDim = min(bounds.width / 2, bounds.height / 2)
        let rad = radius(for: point, from: center) / minDim
        let ang = angle(for: point, from: center)
        let col = color(at: rad, ang)
        return UIColor(red: Int(col.r), green: Int(col.g), blue: Int(col.b))
    }
}
