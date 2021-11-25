//
//  ManageChildrenViewController.swift
//  AlifBee Kids
//
//  Created by Yaman on 26.10.2021.
//  Copyright © 2021 ALEMI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ManageChildrenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var addChildButton: CustomButtonView!
    
    var viewModel: ManageChildrenViewModel!
    let disposeBag = DisposeBag()
    
    convenience init(viewModel: ManageChildrenViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        
        backButton.buttonClickFunction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        addChildButton.buttonClickFunction = {
            self.addChild()
        }
        
        bindChilrdenProgress()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
 
    func registerNib() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ManageChildrenTableViewCell", bundle: nil), forCellReuseIdentifier: "ManageChildrenTableViewCell")
    }
    
    private func bindChilrdenProgress() {
        viewModel.children.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func addChild() {
        let viewModel = ChildInfoViewModel()
        let vc = SelectGenderViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ManageChildrenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageChildrenTableViewCell", for: indexPath) as! ManageChildrenTableViewCell
        cell.setUp(
            child: viewModel.children.value[indexPath.row],
            delegate: self,
            canDelete: viewModel.children.value.count > 1
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.children.value.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ManageChildrenViewController: ManageChildrenTableViewCellDelegate{
    
    func deleteChild(id: Int , name: String){
        viewModel.deleteStudent(id: id)
    }
}
