//
//  ViewController.swift
//  SimpleColorWheelExample
//
//  Created by shout@claudiu.mn on 07.06.2021.
//

import SimpleColorWheel
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var colorWheel: ColorWheelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorWheel.delegate = self
    }
}

extension ViewController: ColorWheelViewDelegate {
    func didStartSelection(in colorWheel: ColorWheelView,
                           with color: UIColor) {
        view.backgroundColor = color
    }
    
    func didChangeSelection(in colorWheel: ColorWheelView,
                            with color: UIColor) {
        view.backgroundColor = color
    }
    
    func didEndSelection(in colorWheel: ColorWheelView,
                         with color: UIColor) {
        view.backgroundColor = color
    }
}
