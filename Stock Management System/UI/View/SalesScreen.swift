//
//  SalesScreen.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 17.05.2024.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class SalesScreen: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var soldProductName: UITextField!
    @IBOutlet weak var stockNumber: UILabel!
    @IBOutlet weak var quantitySold: UITextField!
    @IBOutlet weak var totalPrice: UILabel!
    
    var currentStock: Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantitySold.addTarget(self, action: #selector(quantitySoldChanged), for: .editingChanged)
    }
    
    @IBAction func checkButtonClicked(_ sender: Any) {
        guard let productName = soldProductName.text, !productName.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen ürün adını giriniz.")
            return
        }
        fetchStock(productName: productName)
    }
    
    @IBAction func sellButtonClicked(_ sender: Any) {
        guard let stock = currentStock,
              let quantityString = quantitySold.text, !quantityString.isEmpty,
              let quantity = Float(quantityString) else {
            showAlert(title: "Hata", message: "Lütfen geçerli bir miktar giriniz.")
            return
        }
        
        if quantity > stock.productPieces ?? 0 {
            showAlert(title: "Hata", message: "Yeterli stok yok.")
            return
        }
        
        let total = quantity * (stock.productPrice ?? 0)
        totalPrice.text = "Toplam Satış Fiyatı: \(total) ₺"
        
        // Stok güncelleme
        updateStock(stock: stock, quantitySold: quantity, total: total)
    }
    
    @objc func quantitySoldChanged() {
        guard let stock = currentStock,
              let quantityString = quantitySold.text, !quantityString.isEmpty,
              let quantity = Float(quantityString) else {
            totalPrice.text = "Toplam Satış Fiyatı: 0 ₺"
            totalPrice.textColor = .black
            return
        }

        if quantity > stock.productPieces ?? 0 {
            totalPrice.text = "Yeterli stok yok"
            totalPrice.textColor = .red
        } else {
            let total = quantity * (stock.productPrice ?? 0)
            totalPrice.text = "Toplam Satış Fiyatı: \(total) ₺"
            totalPrice.textColor = .black
        }
    }

    func fetchStock(productName: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("stocks").whereField("productName", isEqualTo: productName).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                self.showAlert(title: "Hata", message: "Ürün aranırken bir hata oluştu.")
            } else if let document = snapshot?.documents.first, let stock = try? document.data(as: Stock.self) {
                self.currentStock = stock
                self.stockNumber.text = "Stok Miktarı: \(stock.productPieces ?? 0)"
            } else {
                self.showAlert(title: "Hata", message: "Ürün bulunamadı.")
            }
        }
    }
    
    func updateStock(stock: Stock, quantitySold: Float, total: Float) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let stockRef = db.collection("users").document(userId).collection("stocks").document(stock.id ?? "")
        
        var updatedStock = stock
        updatedStock.productPieces = (stock.productPieces ?? 0) - quantitySold
        updatedStock.soldNumber = (stock.soldNumber ?? 0) + quantitySold
        
        do {
            try stockRef.setData(from: updatedStock)
            showAlert(title: "Başarılı", message: "Ürün başarıyla satıldı.")
        } catch let error {
            print("Error updating document: \(error)")
            showAlert(title: "Hata", message: "Ürün güncellenirken bir hata oluştu.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alertController, animated: true)
    }
}
