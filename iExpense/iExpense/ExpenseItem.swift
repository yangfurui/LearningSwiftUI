//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Terry on 2023/5/6.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    
    let name: String
    let type: String
    let amount: Double
}
