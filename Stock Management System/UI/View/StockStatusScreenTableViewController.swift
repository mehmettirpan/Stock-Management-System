//
//  StockStatusScreenTableViewController.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 18.05.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StockStatusScreenTableViewController: UITableViewController {

    var stocks: [Stock] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStocks()
    }

    func fetchStocks() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("stocks").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                self.stocks = snapshot?.documents.compactMap { document in
                    try? document.data(as: Stock.self)
                } ?? []
                self.tableView.reloadData()  // stockTableView yerine tableView'i kullanın
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as? StockCell else {
            fatalError("Dequeued cell is not an instance of StockCell.")
        }
        let stock = stocks[indexPath.row]
        cell.configure(with: stock)
        return cell
    }
}

