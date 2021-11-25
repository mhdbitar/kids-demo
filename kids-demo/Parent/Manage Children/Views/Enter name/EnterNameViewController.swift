import UIKit
import RxCocoa
import RxSwift

final class EnterNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: FloatingTextFieldView!
    @IBOutlet weak var SendButton: CustomButtonView!
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var stepText: UILabel!
    @IBOutlet weak var fieldHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ChildInfoViewModel!
    let disposeBag = DisposeBag()
    
    convenience init (viewModel: ChildInfoViewModel){
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.onEditing = {
            self.resetError()
        }

        stepText.text = "Step 2/3"
        SendButton.buttonClickFunction = sendName
        backButton.buttonClickFunction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        nameField.returnFunction = {
            self.sendName()
        }
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.activate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bind(){
        bindName()
        bindSelectedGender()
    }
    
    
    private func bindName() {
        viewModel.name.subscribe(onNext: { [weak self] name in
            self?.nameField.textField.text = name
            
        }).disposed(by: disposeBag)
    }
    
    private func bindSelectedGender() {
        viewModel.selectedGender.subscribe(onNext: { [weak self] gender in
            self?.titleText.text = (gender.rawValue == Gender.Male.rawValue) ? "His name" : "Her name"
        }).disposed(by: disposeBag)
    }
    
    func sendName() {
        let name = nameField.textField.text ?? ""
        if !name.isEmpty && name.count <= 25  && name.count >= 2 {
            viewModel.setName (name: name)
            navigate()
        } else {
            setError(error: "Error")
        }
    }
    
    @objc func SendButtonClick() {
        sendName()
    }
    
    private func setError(error: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            self.nameField.setError(error: error)
            self.fieldHeightConstraint.constant = 85
            self.view.layoutIfNeeded()
        }
    }
    
    private func resetError() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.nameField.resetError()
            self.fieldHeightConstraint.constant = 56
            self.view.layoutIfNeeded()
        }
    }
    
    private func navigate() {
        let controller = SelectAgeViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
