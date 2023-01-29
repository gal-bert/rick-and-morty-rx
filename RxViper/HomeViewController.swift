//
//  ViewController.swift
//  RxViper
//
//  Created by Gregorius Albert on 29/01/23.
//

import UIKit
import Network
import SnapKit

import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    private lazy var refreshButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        view.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "trash"), for: .normal)
        view.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    var obsCharacters = BehaviorRelay<[RMCharacter]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        _ = obsCharacters.subscribe { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()                
            }
        }.disposed(by: disposeBag)
        
        fetchCharacter(id: 1) { [weak self] response in
            self?.handleResponse(response: response)
        }
        
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
    
    @objc func refresh() {
        var nextId = (obsCharacters.value.last?.id ?? 0) + 1
        fetchCharacter(id: nextId) { [weak self] response in
            self?.handleResponse(response: response)
        }
    }
    
    @objc func clearData() {
        obsCharacters.accept([])
    }
    
    private func setupView() {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: refreshButton),
            UIBarButtonItem(customView: deleteButton)
        ]
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let characters = obsCharacters.value
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return obsCharacters.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.obsCharacters = obsCharacters
        vc.index = indexPath.row
        navigationController?.present(vc, animated: true)
    }
    
}
