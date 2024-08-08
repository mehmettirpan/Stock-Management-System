//
//  StockStatusScreen.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 16.05.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StockStatusScreen: UITableViewController {

    @IBOutlet var stockTableView: UITableView!
    
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
                   self.stockTableView.reloadData()
               }
           }
       }

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stocks.count
    }
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stokCell", for: indexPath)
        let stock = stocks[indexPath.row]
        cell.textLabel?.text = stock.productName
        cell.detailTextLabel?.text = "Adet: \(stock.productPieces ?? 0), Fiyat: \(stock.productPrice ?? 0)"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
