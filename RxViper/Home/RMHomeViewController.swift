//
//  RMHomeViewController.swift
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
import SnapKit
import RxSwift
import RxCocoa

// MARK: Protocols

/// Should be conformed to by the `RMHomeViewController` and referenced by `RMHomePresenter`
protocol RMHomePresenterViewProtocol: class {
	/** Sets the title for the view
	- parameters:
		- title The title to set
	*/
	func set(title: String?)
    func reloadData()

}

// MARK: -

/// The View Controller for the RMHome module
class RMHomeViewController: UIViewController, RMHomePresenterViewProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

	// MARK: - Constants

	let presenter: RMHomeViewPresenterProtocol

	// MARK: Variables
    
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
    
    var obsCharacters: BehaviorRelay<[RMCharacter]>?

	// MARK: Inits

	init(presenter: RMHomeViewPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Load Functions

	override func viewDidLoad() {
    	super.viewDidLoad()
		presenter.viewLoaded()
        obsCharacters = presenter.getObsCharacters()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
        
        presenter.requestCharacters()
		
    }
    
    @objc func refresh() {
        presenter.requestCharacters()
    }
    
    @objc func clearData() {
        presenter.deleteAll()
    }
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: refreshButton),
            UIBarButtonItem(customView: deleteButton)
        ]
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

	// MARK: - RMHome Presenter to View Protocol

	func set(title: String?) {
		self.title = title
	}
}

extension RMHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let characters = obsCharacters?.value else { return cell }
        cell.textLabel?.text = characters[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return obsCharacters?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.obsCharacters = obsCharacters
        vc.index = indexPath.row
        navigationController?.present(vc, animated: true)
    }
    
}
