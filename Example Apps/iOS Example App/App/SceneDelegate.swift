import UIKit
import SparrowKit

class SceneDelegate: SPWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        makeKeyAndVisible(in: scene, viewController: ViewController(), tint: .systemBlue)
    }
}

