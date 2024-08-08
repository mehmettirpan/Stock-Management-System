//
//  Stocks.swift
//  Stock Management System
//
//  Created by Mehmet Tırpan on 16.05.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Stock: Codable{
    @DocumentID var id: String?
    var productName: String?
    var productPieces: Float?
    var productPrice: Float?
    var productBuyingPrice: Float?
    var soldNumber: Float?
    var totalNumber: Float?
    var expirationDate: Date
    var date: Date
}

