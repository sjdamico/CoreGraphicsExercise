//
//  ViewController.swift
//  QuartzFun
//
//  Created by Steve D'Amico on 3/24/16.
//  Copyright © 2016 Steve D'Amico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Color Segment control
    @IBAction func changeColor(sender: UISegmentedControl) {
        let drawingColorSelection = DrawingColor(rawValue: UInt(sender.selectedSegmentIndex))
        if let drawingColor = drawingColorSelection {
            let funView = view as! QuartzFunView;
            switch drawingColor {
            case .Red:
                funView.currentColor = UIColor.redColor()
                funView.useRandowmColor = false
                
            case .Blue:
                funView.currentColor = UIColor.blueColor()
                funView.useRandowmColor = false
                
            case .Yellow:
                funView.currentColor = UIColor.yellowColor()
                funView.useRandowmColor = false
                
            case .Green:
                funView.currentColor = UIColor.greenColor()
                funView.useRandowmColor = false
                
            case .Random:
                funView.useRandowmColor = true
            }
        }
    }

    // Image segment control
    @IBAction func ChangeShape(sender: UISegmentedControl) {
        let shapeSelection = Shape(rawValue: UInt(sender.selectedSegmentIndex))
        if let shape = shapeSelection {
            let funView = view as! QuartzFunView;
            funView.shape = shape;
            // Color segment control is hidden when image is chosen
            colorControl.hidden = shape == Shape.Image
        }
    }
}

