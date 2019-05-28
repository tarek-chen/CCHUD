//
//  ViewController.swift
//  CCHUD
//
//  Created by E on 2019/5/27.
//  Copyright © 2019 CHEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	
	let messageString = "动物园里有小猴几🐒、大脑斧🐯还有小西几🦁️小脑许🐭"
	
	
	@IBAction func showMessage(_ sender: UIButton) {
		
		var type: CCHUDType
		let index = sender.tag
		
		switch index {
		case 0:
			type = .top
		break
		case 1:
			type = .center
			break
		case 2:
			type = .bottom
			break
		default:
			type = .center
			break
		}

		hud.type = type
		hud.message = messageString
		hud.show(on: view)
		
		// TODO: 茴字的第二种写法
//		showTopMessage(messageString)
//		showMessage(messageString)
//		showBottomMessage(messageString)
	}
	
	
}

