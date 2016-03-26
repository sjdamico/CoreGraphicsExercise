//
//  QuartzFunView.swift
//  QuartzFun
//
//  Created by Steve D'Amico on 3/24/16.
//  Copyright © 2016 Steve D'Amico. All rights reserved.
//

import UIKit

// Random color extension of UIColor
extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Double(arc4random_uniform(255))/255)
        let green = CGFloat(Double(arc4random_uniform(255))/255)
        let blue = CGFloat(Double(arc4random_uniform(255))/255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// The shapes that can be drawn.
enum Shape : UInt {
    case Line = 0, Rect, Ellipse, Image
}

// The color tab indices
enum DrawingColor : UInt {
    case Red = 0, Blue, Yellow, Green, Random
}

// The drawing view
class QuartzFunView: UIView {
    // Application-settable properties
    var shape = Shape.Line
    var currentColor = UIColor.redColor()
    var useRandowmColor = false
    
    // Internal properties
    private let image = UIImage(named: "iphone")
    private var firstTouchLocation = CGPointZero
    private var lastTouchLocation = CGPointZero
    private var redrawRect = CGRectZero     // Used to keep track of the area that needs to be redrawn
    
    // // First point touched on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if useRandowmColor {
                currentColor = UIColor.randomColor()
            }
            firstTouchLocation = touch.locationInView(self)
            lastTouchLocation = firstTouchLocation
            redrawRect = CGRectZero
            setNeedsDisplay()
        }
    }

    // Is cotinuously called while user is dragging finger on the screen
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.locationInView(self)

            // Recalculates space impacted by current operationto indicate that portion for the redraw
            if shape == .Image {
                let horizontalOffset = image!.size.width/2
                let verticalOffset = image!.size.height/2
                redrawRect = CGRectUnion(redrawRect, CGRectMake(lastTouchLocation.x - horizontalOffset, lastTouchLocation.y -  verticalOffset, image!.size.width, image!.size.height))
            } else {
                redrawRect = CGRectUnion(redrawRect, currentRect())
            }
            setNeedsDisplayInRect(redrawRect)
        }
    }

    // Point where finger is lifted from the screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.locationInView(self)

            // Recalculates space impacted by current operationto indicate that portion for the redraw
            if shape == .Image {
                let horizontalOffset = image!.size.width/2
                let verticalOffset = image!.size.height/2
                redrawRect = CGRectUnion(redrawRect, CGRectMake(lastTouchLocation.x - horizontalOffset, lastTouchLocation.y -  verticalOffset, image!.size.width, image!.size.height))
            } else {
                redrawRect = CGRectUnion(redrawRect, currentRect())
            }
            setNeedsDisplayInRect(redrawRect)
        }
    }
    
    // This code does the drawing of lines or shapes or images
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)     // Sets the line's width
        CGContextSetStrokeColorWithColor(context, currentColor.CGColor)     // Sets the color for the lines
        // Fills the interior of shapes
        CGContextSetFillColorWithColor(context, currentColor.CGColor)

        // Declare rectangle to hold the ellipse or rectangle
        switch shape {
        case .Line:             // Draw a line
            CGContextMoveToPoint(context, firstTouchLocation.x, firstTouchLocation.y)
            CGContextAddLineToPoint(context, lastTouchLocation.x, lastTouchLocation.y)
            CGContextStrokePath(context)
            
        case .Rect:
            CGContextAddRect(context, currentRect())
            CGContextDrawPath(context, .FillStroke)
            
        case .Ellipse:
            CGContextAddEllipseInRect(context, currentRect())
            CGContextDrawPath(context, .FillStroke)
            
        case .Image:            // Calculates the center of the image, center of the image is contact point
            let horizontalOffset = image!.size.width/2
            let veticalOffset = image!.size.height/2
            let drawPoint = CGPoint(x: lastTouchLocation.x - horizontalOffset, y: lastTouchLocation.y - veticalOffset)
            image!.drawAtPoint(drawPoint)
        }
    }

    // Calculates the redrawn rectangle
    func currentRect() -> CGRect {
        return CGRectMake(firstTouchLocation.x, firstTouchLocation.y, lastTouchLocation.x - firstTouchLocation.x, lastTouchLocation.y - firstTouchLocation.y)
    }
}


