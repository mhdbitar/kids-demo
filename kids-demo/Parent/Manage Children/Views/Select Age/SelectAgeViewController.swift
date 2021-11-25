//
//  SelectAgeViewController.swift
//  AlifBee Kids
//
//  Created by Yaman on 3.11.2021.
//  Copyright © 2021 ALEMI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectAgeViewController: UIViewController {
    
    @IBOutlet var selectAgeButtons: [SelectAgeButton]!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var stepText: UILabel!

    var agesArray = [AgeGroups.Age1, AgeGroups.Age2 ,AgeGroups.Age3]
 
    var viewModel: ChildInfoViewModel!
    let disposeBag = DisposeBag()
    var gender : Gender = Gender.NotSet
    var age :AgeGroups = AgeGroups.NotSet
    
    convenience init (viewModel: ChildInfoViewModel){
        self.init()
        self.viewModel = viewModel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        resetButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.buttonClickFunction = {
            self.navigationController?.popViewController(animated: true)
        }
        stepText.text = "Step 3/3"
        bind()
    }
    
    func bind() {
        bindName()
        bindSelectedGender()
        bindSelectedAge()
        bindSubmit()
    }
  
    private func bindSelectedAge() {
        viewModel.selectedAge.subscribe(onNext: { [weak self] age in
            self?.age = age
            self?.setAgeButtons()
        }).disposed(by: disposeBag)
    }
    
    private func bindSelectedGender() {
        viewModel.selectedGender.subscribe(onNext: { [weak self] gender in
            self?.gender = gender
            self?.setAgeButtons()
        }).disposed(by: disposeBag)
    }
    
    private func bindName(){
        viewModel.name.subscribe(onNext: { [weak self] name in
            self?.titleText.text = "How old is \(name)?"
            
        }).disposed(by: disposeBag)
    }
    
    private func bindSubmit(){
        viewModel.submitResult.subscribe(onNext: { [weak self] result in
             if result == 1 {
                self?.displaySuccessMessage()
            }
        }).disposed(by: disposeBag)
    }
    
    private func displaySuccessMessage() {
        // Presnet success message and after that execute the following
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    private func setAgeButtons() {
        self.selectAgeButtons.enumerated().forEach { (index,button) in
            let ageDescrip = self.viewModel.ageDescription(key: agesArray[index].rawValue)
            button.setup(
                ageData: AgeBut(
                    text: ageDescrip,
                    key: agesArray[index],
                    index: index
                ),
                delegateScene: self,
                selectedGender: gender.rawValue
            )
            
            if button.ageBut?.key == age {
                button.animateSelected(selected: true)
            } else {
                button.animateSelected(selected: false)
            }
        }
    }
    
    func resetButtons() {
        viewModel.setAge(age: .NotSet)
        selectAgeButtons.forEach { $0.locked = false }
    }
}


extension SelectAgeViewController: AgeButttonDelegate {
    
    func setAge(ageBut: AgeBut) {
        viewModel.setAge(age: ageBut.key)
        selectAgeButtons.forEach { $0.locked = true }
    }
}
