import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Core Data를 위한 Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Example")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // 앱이 처음 시작될 때 호출되는 메서드
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 앱이 처음 시작될 때 추가적인 설정이 필요하다면 이곳에서 처리
        return true
    }

    // 새로운 Scene Session을 생성할 때 호출되는 메서드
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // 새로운 Scene이 생성될 때 사용할 configuration을 반환
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // 사용자가 Scene Session을 폐기할 때 호출되는 메서드
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Scene Session이 폐기될 때 필요한 처리를 수행
    }

    // Core Data의 변경 사항을 저장하는 메서드
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
