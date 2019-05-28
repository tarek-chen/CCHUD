//
//  StringEx.swift
//  CHEN
//
//  Created by CHEN on 2018/10/23.
//  Copyright © 2018 CHEN. All rights reserved.
//

import UIKit

extension String {
    
    var color: UIColor {
        
        var cStr = uppercased() as NSString
        // strip 0X if it appears
        if cStr.contains("0X") {
            cStr = cStr.substring(from: 2) as NSString
        }
        else if cStr.contains("#") {
            cStr = cStr.substring(from: 1) as NSString
        }
        // String should be 6 or 8 characters
        if cStr.length != 6 {
            return .clear
        }
        //r
        var range = NSMakeRange(0, 2)
        let rStr = cStr.substring(with: range)
        //g
        range.location = 2
        let gStr = cStr.substring(with: range)
        //b
        range.location = 4
        let bStr = cStr.substring(with: range)
        // color
        var r: CUnsignedInt = 0,
        g: CUnsignedInt = 0,
        b: CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(Float(r) / 255.0), green:CGFloat(Float(g) / 255.0), blue:CGFloat(Float(b) / 255.0), alpha:CGFloat(Float(1)))
    }
    
    var cgColor: CGColor {
        return self.color.cgColor
    }
    
    
    var trim: String {
        
        var trimStr: String = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimStr.contains(" ") {
            trimStr = trimStr.replacingOccurrences(of: " ", with: "")
        }
        return trimStr
    }
    
    //MARK: - 格式判定
    var isString: Bool {
        if isEmpty {
            return false
        }
        
        let _isString: Bool = trim.count > 0
        return _isString
    }
    
    // 整形判断
    var isNum: Bool {
        if !isString {
            return false
        }
        let scan: Scanner = Scanner(string: self)
        var val: NSInteger = 0
        let result: Bool = scan.scanInt(&val) && scan.isAtEnd
        return result
    }
    
    
    // 中国的手机区号
    var isChineseCode: Bool {
       
        let code = replacingOccurrences(of: "+", with: "").trim
        let _result: Bool = code == "86" ||
                             code == "866" ||
                             code == "852" ||
                             code == "853"
        return _result
    }
    
    // Email判定
    var isEmail: Bool {
        
        let rule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return predicateRule(rule)
    }
    
    
//    var isPhone: Bool {
//        
//        let rule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//        return predicateRule(rule)
//    }
    
    // 区号匹配
    func checkUsernameForAreaCode(_ areaCode: String) -> Bool {
        
        if isEmail {
            return true
        } else if areaCode.isString {
            let phoneFormat = isPnoneForCode(areaCode)
            return phoneFormat
        }
        return false
    }
    
    var isChinesePhone: Bool {
        
        let rule = "^((0\\d{2,3}-\\d{7,8})|(1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}))$"
        return predicateRule(rule)
    }
    
    var isForeignPhone: Bool {
        
        let rule = "^\\d{5,}$"
        return predicateRule(rule)
    }
    
    // code: +86
    func isPnoneForCode(_ code: String) -> Bool {
        
        if code.isChineseCode {
            return isChinesePhone
        } else {
            return isForeignPhone
        }
    }

    var hadSpecialSymbol: Bool {
        
        return !predicateRule("^[\\x00-\\x7F]*$")
    }
    
    
    var isPasswrod: Bool {
        
        let format: Bool = count > 7 && count < 65
        let isPwd = format && !isNum && !hadSpecialSymbol
        return isPwd
        
    }
    
    //TODO: 正则匹配
    func predicateRule(_ rule: String) -> Bool {
        
        let predicate =  NSPredicate.init(format: "SELF MATCHES %@", rule)
        let _result: Bool = predicate.evaluate(with: self)
        return _result
    }
    
    func checkPassword() -> Bool {
        
        let len = count >= 8 && count <= 64
        guard len  else {
            return false
        }
        // 不能是纯数字
        guard !predicateRule("^[0-9]*$") else {
            return false
        }
        // 非法字符
//        guard !predicateRule("^[\x00-\x7F]*$"'<#String#>') else {
//            return false
//        }
        return true
    }
    
    //MARK: - 格式处理
    var jsonDic: Dictionary<String, Any>? {
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
        if dict == nil {
            return Dictionary()
        }
        return (dict as! Dictionary<String, Any>)
    }
    
    var jsonData: Data? {
        
        let jsonData :Data = data(using: .utf8)!
        return jsonData
    }

    var URL: URL {
        return NSURL(string: self)! as URL
    }
    
    var image: UIImage? {
		if !isString {
			return nil
		}
        return UIImage(named: self)
    }
    
    var mosaicStyle: String {
        
        if isEmail {
            
            let subMail: Array = components(separatedBy: "@")
            var prefix = subMail[0]
            var cutCount = prefix.count - 2
            cutCount = max(cutCount, 1)
            prefix = String(prefix.dropLast(cutCount))
            let mosaicMail = prefix + "****@" + subMail[1]
            return mosaicMail
        }
        
        // 手机打码
        let range: NSRange = count > 7 ? NSMakeRange(3, 4): NSMakeRange(1, 2)
        var phone: NSString = NSString(string: self)
        phone = phone.replacingCharacters(in: range, with: "****") as NSString
    
        return phone as String
    }
    
    // 下标截取单个字符
    func subString(atIndex: NSInteger) -> String {
        let sub = self.dropLast(self.count - atIndex - 1)
        return String(sub.last!)
    }
    
    //MARK: - 计算处理
    fileprivate func getFrameWithFont(size: CGSize,_ font: UIFont) -> CGRect {
        
        let rect:CGRect = self.boundingRect(with: size, options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context:nil);
        
        return rect
    }
    
    // 获取展示宽度
    func getTextWidthForHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        return getFrameWithFont(size: CGSize(width: CGFloat(MAXFLOAT), height: height), font).width
    }
    
    // 获取展示高度
    func getTextHeightForWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
      return getFrameWithFont(size: CGSize(width: width, height: CGFloat(MAXFLOAT)), font).height
    }
    
    // 获取字串结束位置
    func getLastLineWidth(_ labelWidth: CGFloat, font: UIFont) -> CGFloat {
        
        let singleLineLength = NSInteger(getTextWidthForHeight(30, font: font))
        var finalWidth : NSInteger = singleLineLength
        if singleLineLength > NSInteger(labelWidth) {
            finalWidth = singleLineLength % NSInteger(labelWidth)
        }
        return CGFloat(finalWidth)
    }
    
    //MARK: - 通知
    func post() {
        
        post(obj: nil)
    }
    
    func post(obj: Any?) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self), object: obj)
    }
    
    func receive(observer: Any,_ forMethod: Selector!) {
        
        receive(observer: observer, forMethod, obj: nil)
    }
    
    func receive(observer: Any,_ forMethod: Selector!, obj: Any?) {
        NotificationCenter.default.addObserver(observer, selector: forMethod, name: NSNotification.Name(rawValue: self), object: obj)
    }
    
    func remove(observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: self), object: nil)
    }
   
}
