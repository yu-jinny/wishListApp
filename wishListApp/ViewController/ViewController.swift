import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Core Data에서 사용할 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // currentProduct가 set되면 UI 업데이트를 수행합니다.
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            updateUIWithCurrentProduct()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRemoteProduct()
    }
    
    // 위시 리스트에 담기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        saveWishProduct()
    }
    
    // 다음 상품 보기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        fetchRemoteProduct()
    }
    
    // 위시 리스트 보기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedPresentWishList(_ sender: UIButton) {
        presentWishListViewController()
    }
    
    // URLSession을 통해 RemoteProduct를 가져와 currentProduct 변수에 저장합니다.
    private func fetchRemoteProduct() {
        let productID = Int.random(in: 1 ... 100)
        
        guard let url = URL(string: "https://dummyjson.com/products/\(productID)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                    self?.currentProduct = product
                } catch {
                    print("Decode Error: \(error)")
                }
            }
        }
        
        task.resume()
    }

    // currentProduct를 가져와 Core Data에 저장합니다.
    private func saveWishProduct() {
        guard let context = persistentContainer?.viewContext, let currentProduct = currentProduct else { return }

        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price

        try? context.save()
    }
    
    // WishListViewController를 가져와 present 합니다.
    private func presentWishListViewController() {
        guard let wishListVC = storyboard?.instantiateViewController(identifier: "WishListViewController") as? WishListViewController else { return }
        
        present(wishListVC, animated: true)
    }
    
    // UI 업데이트를 수행합니다.
    private func updateUIWithCurrentProduct() {
        guard let currentProduct = currentProduct else { return }

        DispatchQueue.main.async {
            self.imageView.image = nil
            self.titleLabel.text = currentProduct.title
            self.descriptionLabel.text = currentProduct.description
            self.priceLabel.text = "\(currentProduct.price)$"
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                DispatchQueue.main.async { self?.imageView.image = image }
            }
        }
    }
}
