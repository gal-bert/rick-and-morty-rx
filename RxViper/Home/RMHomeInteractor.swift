//
//  RMHomeInteractor.swift
//  Project: RxViper
//
//  Module: RMHome
//
//  By Gregorius Albert 29/01/23
//  ___ORGANIZATIONNAME___ 2023
//

// MARK: Imports

import Foundation
import SwiftyVIPER
import Network

import RxSwift
import RxCocoa

// MARK: Protocols

/// Should be conformed to by the `RMHomeInteractor` and referenced by `RMHomePresenter`
protocol RMHomePresenterInteractorProtocol {
	/// Requests the title for the presenter
	func requestTitle()
    func getObsCharacters() -> BehaviorRelay<[RMCharacter]>
    func requestCharacters()
    func deleteAll()
}

// MARK: -

/// The Interactor for the RMHome module
final class RMHomeInteractor: RMHomePresenterInteractorProtocol {
    func deleteAll() {
        obsCharacters.accept([])
    }
    
    func requestCharacters() {
        let id = obsCharacters.value.last?.id ?? 0
        fetchCharacter(id: id + 1) { [weak self] response in
            self?.handleResponse(response: response)
        }
        
    }
    
    
    func getObsCharacters() -> BehaviorRelay<[RMCharacter]> {
        return obsCharacters
    }
    
    

	// MARK: - Variables
    
    var obsCharacters = BehaviorRelay<[RMCharacter]>(value: [])
    var disposeBag = DisposeBag()
    
	weak var presenter: RMHomeInteractorPresenterProtocol?
    
    init() {
        setupObserver()
    }
    
    func setupObserver() {
        _ = obsCharacters.subscribe { _ in
            self.presenter?.reloadData()
        }.disposed(by: disposeBag)
    }
    
    func handleResponse(response: Result<RMCharacter, Error>) {
        switch response {
            
        case .success(let character):
            var characters = self.obsCharacters.value // Get old value
            characters.append(character) // Append new value to old value
            self.obsCharacters.accept(characters) // Change the observer

        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func fetchCharacter(id: Int, completion: @escaping (Result<RMCharacter, Error>) -> Void) {
        let endpoint = "https://rickandmortyapi.com/api/character/\(id)"
        let url = URL(string: endpoint)
        
        var request: URLRequest
        
        if let url = url {
            request = URLRequest(url: url)
            var task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    do{
                        let character = try JSONDecoder().decode(RMCharacter.self, from: data)
                        completion(.success(character))
                    } catch {
                        print("JSON Decoder error:", error.localizedDescription)
                        completion(.failure(error))
                    }
                } else {
                    print("Data error:", error!.localizedDescription)
                    completion(.failure(error!))
                }
            }
            task.resume()
        }
    }

	// MARK: - RMHome Presenter to Interactor Protocol

	func requestTitle() {
		presenter?.set(title: "RMHome")
	}
}
