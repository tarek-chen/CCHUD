//
//  CCBaseHUD.swift
//  EirenEx
//
//  Created by E on 2019/5/27.
//  Copyright © 2019 EirenEx. All rights reserved.
//

import UIKit

class CCBaseHUD: UIView {
	
	var type: CCHUDType!
	var message: String!
	var forceEvent: UITapGestureRecognizer?
	var indicator: UIActivityIndicatorView!

	lazy var gestureView: UIView = {
		let gesView = UIView(frame: UIScreen.main.bounds)
		return gesView
	}()
	
	lazy var content: UILabel = {
		
		let frame = CGRect(x: CCMargin, y: kStatusBarHeight, width: self.frame.width - CCMargin*2, height: kNaviBarHeight)
		let _content = UILabel(frame: frame)
		_content.numberOfLines = 0;
		_content.lineBreakMode = .byWordWrapping;
		_content.textColor = "#F5F5F5".color;
		addSubview(_content)
		_content.font = UIFont(name: "PingFang-SC-Medium", size: 18)
		_content.textAlignment = .center;
		_content.isUserInteractionEnabled = true
		return _content
	}()
	
	func viewSettings() {
		self.alpha = 0.8
		isHidden = false
		content.text = message
		resetFrame()
		if .top != type {
			layer.cornerRadius = 4.0
		} else {
			layer.cornerRadius = 0
		}
	}
	
}


typealias HUDSettings = CCBaseHUD
extension HUDSettings {
	
	func resetFrame() {
		switch type! {
		case .top:
			setTopFrame(show: false)
			break
		case .center:
			setCenterFrame()
			break
		case .bottom:
			setBottomFrame()
			break
		case .hud:
			break
		}
		setMessageFrame()
	}
	
	func setTopFrame(show: Bool) {
		let textWith = kScreenWidth - CCMargin*2
		let textHeight = message.getTextHeightForWidth(textWith, font: content.font)
		var finalHeight = kTopHeight
		if textHeight > kNaviBarHeight {
			finalHeight = textHeight + kStatusBarHeight + CCMargin
			let y = show ? kZero : -finalHeight
			frame = CGRect(x: kZero, y: y, width: kScreenWidth, height: finalHeight)
		}
	}
	func setCenterFrame() {
		
		setBottomFrame()
		setFinalWidth()
		center = superview!.center
	}
	
	func setBottomFrame() {
		
		let width = kScreenWidth - CCPadding*2
		let textWith = width - CCMargin*2
		let textHeight = message.getTextHeightForWidth(textWith, font: content.font)
		let height = textHeight + CCMargin*2
		let y = kScreenHeight - height - CCPadding
		let finalX = (kScreenWidth - width)/2
		frame = CGRect(x: finalX, y: y, width: width, height: height)
		setFinalWidth()
	}
	
	func setFinalWidth() {
		let textHeight = self.frame.height - CCMargin*2
		let textWidth = message.getTextWidthForHeight(textHeight, font: content.font)
		if textWidth < (frame.width - CCMargin*2) {
			let finalWidth = textWidth + CCMargin*2
			let finalX = (kScreenWidth - finalWidth)/2
			let finalFrame = CGRect(x: finalX, y: frame.minY, width: finalWidth, height: frame.height)
			frame = finalFrame
		}
	}
	
	func setMessageFrame() {
		let y = type == .top ? kStatusBarHeight : CCMargin
		let height = frame.height - y - CCMargin
		content.frame = CGRect(x: CCMargin, y: y, width: frame.width - CCMargin*2, height: height)
	}

	func finalStyle() {
		switch type! {
		case .top:
			setTopFrame(show: true)
		default:
			self.alpha = 1
		}
	}
	
}

private let CCPadding: CGFloat = 40
private let CCMargin: CGFloat = 10
// TODO: 菊花样式
typealias CCProgressHUD = CCBaseHUD
extension CCProgressHUD {
	
	open class func show() {
		keyWindow.addSubview(CCHUD.shared.gestureView)
		CCHUD.shared.gestureView.isHidden = false
		if CCHUD.shared.indicator == nil {
			CCHUD.shared.loadIndicatorView()
		} else {
			let window = UIApplication.shared.keyWindow!
			window.addSubview(CCHUD.shared)
			CCHUD.shared.alpha = 1
			CCHUD.shared.isHidden = false
			CCHUD.shared.indicator.isHidden = false
		}
		CCHUD.shared.indicator.startAnimating()
	}
	
	func loadIndicatorView() {
		let progressWidth: CGFloat = 80
		backgroundColor = .black
		layer.cornerRadius = 4
		frame = CGRect(x: kZero, y: kZero, width: progressWidth, height: progressWidth)
		let window = UIApplication.shared.keyWindow!
		window.addSubview(CCHUD.shared)

		indicator = UIActivityIndicatorView()
		indicator.color = .lightGray
		indicator.frame = CGRect(x: kZero, y: kZero, width: 40, height: 40)
		let center = progressWidth / 2
		indicator.center = CGPoint(x: center, y: center)
		addSubview(indicator)
		indicator.hidesWhenStopped = true
	}
	
	open class func dismiss() {
		CCHUD.shared.gestureView.isHidden = true
		if CCHUD.shared.indicator != nil {
			CCHUD.shared.indicator.stopAnimating()
			CCHUD.shared.dismiss()
		}
	}
}
