//
//  CustomModalModel.swift
//  CodingTest
//
//  Created by Saif Adel on 10/11/25.
//

import UIKit

protocol ModalVCDelegate: AnyObject {
    func dismissWith(_ vm: STModalAction<Any>)
}

class ModalContainerView: UIView {
    var dismissWith: ((STModalAction<Any>) -> Void)?
}

enum STModalAction<T> {
    case cancel(action: Bool? = nil, view: ModalContainerView? = nil)
    case Ok(T, view: ModalContainerView? = nil)
}
