import UIKit
import RxSwift
import RxCocoa

final class SelectGenderViewController: UIViewController {
    
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var stepText: UILabel!
    @IBOutlet weak var girlButton: SelectGenderButton!
    @IBOutlet weak var boyButton: SelectGenderButton!
    
    var viewModel: ChildInfoViewModel!
    let disposeBag = DisposeBag()
    
    convenience init (viewModel: ChildInfoViewModel){
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.buttonClickFunction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        stepText.text = "Step 1/3"
        girlButton.setup(gender: "f",delegateView: self)
        boyButton.setup(gender: "m",delegateView: self)
        bindSelectedGender()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        resetButtons()
    }
    
    private func bindSelectedGender(){
        viewModel.selectedGender.subscribe(onNext: { [weak self] gender in
            if gender.rawValue == Gender.Male.rawValue {
                self?.girlButton.setup(gender: "f", delegateView: self)
                self?.boyButton.setup(gender: "m",delegateView: self, selected: true)
            } else if gender.rawValue == Gender.Female.rawValue {
                self?.girlButton.setup(gender: "f",delegateView: self, selected: true )
                self?.boyButton.setup(gender: "m",delegateView: self)
            } else {
                self?.girlButton.setup(gender: "f",delegateView: self, selected: false )
                self?.boyButton.setup(gender: "m",delegateView: self)
            }
        }).disposed(by: disposeBag)
    }
    
    func resetButtons(){
        boyButton.locked = false
        girlButton.locked = false
        viewModel.setGender (gender: Gender.NotSet.rawValue)
    }
}

extension SelectGenderViewController: GenderButttonDelegate {
    
    func setGender(gender: String) {
        viewModel.setGender(gender: gender)
        boyButton.locked = true
        girlButton.locked = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.navigationController?.pushViewController(EnterNameViewController(viewModel: self.viewModel), animated: true)
        }
    }
}
