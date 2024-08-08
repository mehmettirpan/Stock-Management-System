//
//  StockStatusTableViewCell.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 17.05.2024.
//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productSellPrice: UILabel!
    @IBOutlet weak var productBuyingPrice: UILabel!
    @IBOutlet weak var productPieces: UILabel!
    @IBOutlet weak var productSoldNumber: UILabel!
    @IBOutlet weak var totalStockNumber: UILabel!
    @IBOutlet weak var addDate: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(with stock: Stock) {
        productName.text = stock.productName
        productSellPrice.text = "Satış Fiyatı: \(stock.productPrice ?? 0)"
        productBuyingPrice.text = "Alış Fiyatı: \(stock.productBuyingPrice ?? 0)"
        productPieces.text = "Stok Miktarı: \(stock.productPieces ?? 0)"
        productSoldNumber.text = "Satılan: \(stock.soldNumber ?? 0)"
        totalStockNumber.text = "Toplam Stok: \(stock.totalNumber ?? 0)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        addDate.text = "Eklenme Tarihi: \(dateFormatter.string(from: stock.date))"
        expirationDate.text = "Son Kullanma Tarihi: \(dateFormatter.string(from: stock.expirationDate))"
    }

}
