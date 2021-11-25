import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationController.setViewControllers([makeRootViewController()], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func makeRootViewController() -> ManageChildrenViewController {
        let child = Child(
            id: 1,
            name: "name",
            gender: "m",
            birthYear: 2018,
            learningLanguage: "en",
            avatar: "Setting-Boy-avatar",
            classroomId: 1,
            ageGroup: "3-5",
            finishedLessons: 4,
            allLessons: 10,
            elapsedTime: "200",
            progress: 0.4)
        SharedData.shared.children = [child]
        let viewModel = ManageChildrenViewModel(children: .init(value: [child]))
        let vc = ManageChildrenViewController(viewModel: viewModel)
        return vc
    }
}

