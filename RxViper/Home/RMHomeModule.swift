//
//  RMHomeModule.swift
//  Project: RxViper
//
//  Module: RMHome
//
//  By Gregorius Albert 29/01/23
//  ___ORGANIZATIONNAME___ 2023
//

// MARK: Imports

import SwiftyVIPER
import UIKit

// MARK: -

/// Used to initialize the RMHome VIPER module
final class RMHomeModule: ModuleProtocol {

	// MARK: - Variables

	private(set) lazy var interactor: RMHomeInteractor = {
		RMHomeInteractor()
	}()

	private(set) lazy var router: RMHomeRouter = {
		RMHomeRouter()
	}()

	private(set) lazy var presenter: RMHomePresenter = {
		RMHomePresenter(router: self.router, interactor: self.interactor)
	}()

	private(set) lazy var view: RMHomeViewController = {
		RMHomeViewController(presenter: self.presenter)
	}()

	// MARK: - Module Protocol Variables

	var viewController: UIViewController {
		return view
	}

	// MARK: Inits

	init() {
		presenter.view = view
		router.viewController = view
		interactor.presenter = presenter
	}
}
