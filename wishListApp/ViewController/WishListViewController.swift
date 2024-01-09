//
//  WishListViewController.swift
//  wishListApp
//
//  Created by t2023-m0028 on 1/9/24.
//import UIKit
import CoreData
import UIKit

class WishListViewController: UITableViewController {
    
    // Core Data에서 사용할 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // 테이블 뷰에 표시할 상품 리스트
    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchProductList()
    }
    
    // 테이블 뷰 설정
    private func setupTableView() {
        self.tableView.dataSource = self
    }
    
    // CoreData에서 상품 정보를 불러와, productList 변수에 저장
    private func fetchProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            // Core Data에서 상품 정보를 불러와 productList에 저장
            productList = try context.fetch(request)
        } catch {
            print("상품 정보를 불러오는 데 실패했습니다: \(error.localizedDescription)")
        }
    }
    
    // 테이블 뷰 데이터 소스 메서드 - 셀 개수 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    // 테이블 뷰 데이터 소스 메서드 - 각 셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = productList[indexPath.row]
        
        // 상품 정보를 셀에 표시
        let id = product.id
        let title = product.title
        let price = product.price
        
        if let unwrappedTitle = product.title {
            cell.textLabel?.text = "[\(id)] \(unwrappedTitle) - \(price)$"
        } else {
            cell.textLabel?.text = "[\(id)] No Title - \(price)$"
        }
        return cell
    }
}
