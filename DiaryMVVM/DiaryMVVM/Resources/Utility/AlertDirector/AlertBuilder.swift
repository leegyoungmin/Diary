//
//  AlertBuilder.swift
//  DiaryMVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol AlertBuilder: AnyObject {
    var controller: UIAlertController { get }
    
    func setTitle(with title: String) -> AlertBuilder
    func setMessage(with message: String) -> AlertBuilder
    func setButton(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    
    func build() -> UIAlertController
}

class AlertConcreteBuilder: AlertBuilder {
    var controller: UIAlertController
    
    init(controller: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)) {
        self.controller = controller
    }
    
    func setTitle(with title: String) -> AlertBuilder {
        controller.title = title
        
        return self
    }
    
    func setMessage(with message: String) -> AlertBuilder {
        controller.message = message
        
        return self
    }
    
    func setButton(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> AlertBuilder {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        controller.addAction(alertAction)
        
        return self
    }
    
    func build() -> UIAlertController {
        return controller
    }
}
