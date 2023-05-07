//
//  ContentView.swift
//  iExpense
//
//  Created by Terry on 2023/5/6.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                if !getPersonalItems().isEmpty {
                    Section("Personal") {
                        ForEach(getPersonalItems()) { item in
                            ItemView(item: item)
                        }
                        .onDelete(perform: removePersonalItems(at:))
                    }
                }
                
                if !getBusinessItems().isEmpty {
                    Section("Business") {
                        ForEach(getBusinessItems()) { item in
                            ItemView(item: item)
                        }
                        .onDelete(perform: removeBusinessItems(at:))
                    }
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let removeItem = getPersonalItems()[index]
            expenses.items.removeAll { $0.id == removeItem.id }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let removeItem = getBusinessItems()[index]
            expenses.items.removeAll { $0.id == removeItem.id }
        }
    }
    
    func getPersonalItems() -> [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    
    func getBusinessItems() -> [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
}

fileprivate struct ItemView: View {
    var item: ExpenseItem
    
    private let currencyCode = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(colorForItemAmount(item.amount))
                
                Text(item.type)
                    .foregroundColor(colorForItemAmount(item.amount))
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: currencyCode))
                .foregroundColor(colorForItemAmount(item.amount))
        }
    }
    
    func colorForItemAmount(_ amount: Double) -> Color {
        return amount >= 100 ? .red : (amount >= 10 ? .blue : .green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
