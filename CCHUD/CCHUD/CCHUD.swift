//
//  CCHUD.swift
//  CCHUD
//
//  Created by E on 2019/5/27.
//  Copyright © 2019 CCHUD. All rights reserved.
//

import UIKit

enum CCHUDType {
	case top
	case center
	case bottom
	case hud
}

enum CCHUDStyle {
	case success
	case error
}

class CCHUD: CCBaseHUD {
	static var shared = CCHUD()

	var tapDissmiss: Bool? {
		willSet {
			if (newValue != nil) {
				addTapDissmissEvent()
			} else {
				gestureView.removeFromSuperview()
			}
		}
	}
	
	class func hud(_ type: CCHUDType!, message: String!) -> CCHUD {
		let hud = CCHUD()
		hud.type = type
		hud.message = message
		return hud
	}
	
	override func viewSettings() {
		super.viewSettings()
		backgroundColor = .black
		content.textColor = .white
	}
	
	func show(on view: UIView?) {
		if view == nil {
			UIApplication.shared.keyWindow!.addSubview(self)
		} else {
			view?.addSubview(self)
		}
		tapDissmiss = true
		viewSettings()
		
		// 取消最近一次的延时消失事件
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
		UIView.animate(withDuration: 0.3, animations: {
			self.finalStyle()
		}) { (finish) in
			self.perform(#selector(self.dismiss), with: nil, afterDelay: 2)
		}
	}
	
	@objc
	func dismiss() {
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
		UIView.animate(withDuration: 0.5, animations: {
			self.alpha = kZero
		}) { (end) in
			self.isHidden = true
			self.gestureView.isHidden = true
			self.gestureView.removeFromSuperview()
			self.removeFromSuperview()
		}
	}
	
	// TODO: 点击消失
	func addTapDissmissEvent() {
		superview?.addSubview(gestureView)

		if forceEvent == nil {
			forceEvent = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
		}
		
		switch type! {
		case .top:
			gestureView.isHidden = true
			addGestureRecognizer(forceEvent!)
			break
		default:
			gestureView.isHidden = false
			gestureView.addGestureRecognizer(forceEvent!)
			break
		}
	}
}

var CCHUDKEY = "CCHUDKEY"
extension NSObject {
	var hud: CCHUD {
		set {
			objc_setAssociatedObject(self, &CCHUDKEY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
		get {
			if let _hud = objc_getAssociatedObject(self, &CCHUDKEY) as? CCHUD {
				return _hud
			}
			self.hud = CCHUD()
			return self.hud
		}
	}
	
	func showTopMessage(_ message: String) {
		hud.type = .top
		hud.message = message
		hud.show(on: nil)
	}
	func showMessage(_ message: String) {
		hud.type = .center
		hud.message = message
		hud.show(on: nil)
	}
	func showBottomMessage(_ message: String) {
		hud.type = .bottom
		hud.message = message
		hud.show(on: nil)
	}
	
	// TODO: 菊花样式
	func showHUD() {
		CCHUD.show()
	}
	
	func dismissHUD() {
		CCHUD.dismiss()
	}
}
