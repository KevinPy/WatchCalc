//
//  InterfaceController.swift
//  Watch Calc WatchKit Extension
//
//  Created by Kevin on 05/01/2015.
//  Copyright (c) 2015 Kevin Py. All rights reserved.
//

import WatchKit
import Foundation

enum Operation {
	case Unknown, Add, Substract, Multiply, Divide
}

class Calc {
	
	var operation: Operation = .Unknown
	var result: Float = 0
	
	class var shared : Calc {
		
		struct Static {
			static let instance = Calc()
		}
		
		return Static.instance
		
	}
	
	func calculate(input: Float) {
		
		switch operation {
			
			case .Add:
				result = result + input
			case .Substract:
				result = result - input
			case .Multiply:
				result = result * input
			case .Divide:
				result = result / input
			case _: break
			
		}
		
	}
	
	func clear() {
		
		result = 0
		operation = .Unknown
		
	}
	
}

class InterfaceController: WKInterfaceController {

	@IBOutlet weak var resultLabel: WKInterfaceLabel!
	private var displayNumber: String = "0"

	// Numbers
	
	@IBAction func zero()	{ addToDisplay("0") }
	@IBAction func one()	{ addToDisplay("1") }
	@IBAction func two()	{ addToDisplay("2") }
	@IBAction func three()	{ addToDisplay("3") }
	@IBAction func four()	{ addToDisplay("4") }
	@IBAction func five()	{ addToDisplay("5") }
	@IBAction func six()	{ addToDisplay("6") }
	@IBAction func seven()	{ addToDisplay("7") }
	@IBAction func eight()	{ addToDisplay("8") }
	@IBAction func nine()	{ addToDisplay("9") }
	
	// Others
	
	@IBAction func decimal() { addToDisplay(".") }
	@IBAction func equal() {
		
		Calc.shared.calculate((displayNumber as NSString).floatValue)
		displayNumber = NSString(format: "%.1f", Calc.shared.result)
		resultLabel.setText(displayNumber)
		Calc.shared.clear()
		
	}
	
	// Operators
	
	@IBAction func add()		{ saveOperation(.Add) }
	@IBAction func substract()	{ saveOperation(.Substract) }
	@IBAction func multiply()	{ saveOperation(.Multiply) }
	@IBAction func divide()		{ saveOperation(.Divide) }
	
	// Menu
	
	@IBAction func remove() {
		if countElements(displayNumber) <= 1 {
			displayNumber = "0"
		} else {
			displayNumber = displayNumber.substringFromIndex(advance(displayNumber.endIndex, -1))
		}
		resultLabel.setText(displayNumber)
	}
	
	@IBAction func clear() {
		Calc.shared.clear()
		displayNumber = "0"
		resultLabel.setText(displayNumber)
	}
	
	// Functions
	
	func saveOperation(op: Operation) {
		
		Calc.shared.result = (displayNumber as NSString).floatValue
		Calc.shared.operation = op
		displayNumber = "0"
		resultLabel.setText(displayNumber)
		
	}
	
	func addToDisplay(stringToAdd: String) {
		
		if stringToAdd == "." {
			
			if displayNumber.rangeOfString(".") == nil {
				displayNumber = displayNumber.stringByAppendingString(".")
			}
			
		} else {
			if displayNumber == "0" {
				displayNumber = stringToAdd
			} else {
				displayNumber = displayNumber.stringByAppendingString(stringToAdd)
			}
		}
		
		resultLabel.setText(displayNumber)
		
	}
	
	// Base
	
    override init(context: AnyObject?) {
        super.init(context: context)
    }

    override func willActivate() {
        super.willActivate()
        NSLog("%@ will activate", self)
    }

    override func didDeactivate() {
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }

}
