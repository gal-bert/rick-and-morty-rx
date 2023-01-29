//
//  DetailViewController.swift
//  RxViper
//
//  Created by Gregorius Albert on 29/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DetailViewController: UIViewController {
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "trash"), for: .normal)
        view.addTarget(self, action: #selector(deleteObject), for: .touchUpInside)
        return view
    }()
    
    var obsCharacters: BehaviorRelay<[RMCharacter]>?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        nameLabel.text = obsCharacters?.value[index!].name
        
    }
    
    @objc private func deleteObject() {
//        obsCharacters?.accept([]) // Delete all
        guard var characters = obsCharacters?.value, let index = index else { return }
        characters.remove(at: index)
        obsCharacters?.accept(characters)
        dismiss(animated: true)
        
    }
    
    func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }


}
