//
//  RMHomePresenter.swift
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
import RxSwift
import RxCocoa

// MARK: Protocols

/// Should be conformed to by the `RMHomePresenter` and referenced by `RMHomeViewController`
protocol RMHomeViewPresenterProtocol: ViewPresenterProtocol {
    func getObsCharacters() -> BehaviorRelay<[RMCharacter]>
    func requestCharacters()
    func deleteAll()
}

/// Should be conformed to by the `RMHomePresenter` and referenced by `RMHomeInteractor`
protocol RMHomeInteractorPresenterProtocol: class {
	/** Sets the title for the presenter
	- parameters:
		- title The title to set
	*/
	func set(title: String?)
    func reloadData()
}

// MARK: -

/// The Presenter for the RMHome module
final class RMHomePresenter: RMHomeViewPresenterProtocol, RMHomeInteractorPresenterProtocol {
    
    func reloadData() {
        view?.reloadData()
    }
    
    
    func requestCharacters() {
        interactor.requestCharacters()
    }

    func deleteAll() {
        interactor.deleteAll()
    }
    
    
    func getObsCharacters() -> BehaviorRelay<[RMCharacter]> {
        interactor.getObsCharacters()
    }
    

	// MARK: - Constants

	let router: RMHomePresenterRouterProtocol
	let interactor: RMHomePresenterInteractorProtocol

	// MARK: Variables

	weak var view: RMHomePresenterViewProtocol?

	// MARK: Inits

	init(router: RMHomePresenterRouterProtocol, interactor: RMHomePresenterInteractorProtocol) {
		self.router = router
		self.interactor = interactor
	}

	// MARK: - RMHome View to Presenter Protocol

	func viewLoaded() {
		interactor.requestTitle()
	}

	// MARK: - RMHome Interactor to Presenter Protocol

	func set(title: String?) {
		view?.set(title: title)
	}
}
