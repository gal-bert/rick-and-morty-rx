//
//  RMHomeRouter.swift
//  Project: RxViper
//
//  Module: RMHome
//
//  By Gregorius Albert 29/01/23
//  ___ORGANIZATIONNAME___ 2023
//

// MARK: Imports

import UIKit

import SwiftyVIPER

// MARK: Protocols

/// Should be conformed to by the `RMHomeRouter` and referenced by `RMHomePresenter`
protocol RMHomePresenterRouterProtocol: PresenterRouterProtocol {

}

// MARK: -

/// The Router for the RMHome module
final class RMHomeRouter: RouterProtocol, RMHomePresenterRouterProtocol {

	// MARK: - Variables

	weak var viewController: UIViewController?
}
