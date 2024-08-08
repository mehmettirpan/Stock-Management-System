//
//  AddStockScreen.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 16.05.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddStockScreen: UIViewController {

    
    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPiecesTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productBuyingPriceTextField: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var expirationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stokEkleTapped(_ sender: UIButton) {
            guard let productName = productNameTextField.text, !productName.isEmpty,
                  let productPiecesString = productPiecesTextField.text, !productPiecesString.isEmpty,
                  let productPieces = Float(productPiecesString),
                  let productPriceString = productPriceTextField.text, !productPriceString.isEmpty,
                  let productPrice = Float(productPriceString),
                  let productBuyingPriceString = productBuyingPriceTextField.text, !productBuyingPriceString.isEmpty,
                  let productBuyingPrice = Float(productBuyingPriceString) else {
                // Hata mesajı göster
                return
            }

            let expirationDate = expirationDatePicker.date
            let date = Date()
            
            addStock(productName: productName, productPieces: productPieces, productPrice: productPrice, productBuyingPrice: productBuyingPrice, expirationDate: expirationDate, date: date)
        }

        func addStock(productName: String, productPieces: Float, productPrice: Float, productBuyingPrice: Float, expirationDate: Date, date: Date) {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            let newStock = Stock(productName: productName, productPieces: productPieces, productPrice: productPrice, productBuyingPrice: productBuyingPrice, soldNumber: 0, totalNumber: productPieces, expirationDate: expirationDate, date: date)
            do {
                try db.collection("users").document(userId).collection("stocks").addDocument(from: newStock)
                // Başarı mesajı göster
                navigationController?.popViewController(animated: true)
            } catch let error {
                print("Error writing document: \(error)")
                // Hata mesajı göster
            }
        }


}
