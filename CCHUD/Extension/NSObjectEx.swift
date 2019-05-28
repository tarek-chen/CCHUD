//
//  NSObjectEx.swift
//  CCHUD
//
//  Created by CHEN on 2018/11/6.
//  Copyright © 2018 CCHUD. All rights reserved.
//

import UIKit

extension NSObject {
    
	class var topVC: UIViewController {
    
        return NSObject().topVC
    }
    
	var topVC: UIViewController {
        
        var result = UIApplication.shared.keyWindow?.rootViewController?.getRootVC()
        
        if (result!.presentedViewController != nil) {
            result = result!.presentedViewController!.getRootVC()!
        }
        return result as! UIViewController
    }
    
    
    func getRootVC() -> UIViewController? {
        if isKind(of: UINavigationController.self) {
            return (self as! UINavigationController).topViewController!.getRootVC()!
        }
        else if isKind(of: UITabBarController.self) {
            return (self as! UITabBarController).selectedViewController?.getRootVC()
        } else if self.isKind(of: UIViewController.self) {
            return (self as! UIViewController)
        }
        return nil
    }
    
}
