import UIKit
import RxSwift
import RxCocoa

final class ManageChildrenViewModel {
    
    var children: BehaviorRelay<[Child]> = .init(value: [])
    
    init(children: BehaviorRelay<[Child]>) {
        self.children = children
    }
    
    func deleteStudent(id: Int) {
        SharedData.shared.children = children.value.filter { $0.id != id }
    }
}
