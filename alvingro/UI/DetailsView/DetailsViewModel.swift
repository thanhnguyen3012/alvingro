//
//  DetailsViewModel.swift
//  alvingro
//
//  Created by Thành Nguyên on 28/05/2021.
//

import Foundation

protocol DetailsViewModelEvents: AnyObject {
    func changeAmountFail(message: String, disableIncreaseButton: Bool, disableDecreaseButton: Bool)
    func changeAmount(amount: Int, disableIncreaseButton: Bool, disableDecreaseButton: Bool)
}

class DetailsViewModel {
    
    weak var delegate: DetailsViewModelEvents?
    var product = Product()
    var amount = 1
    
    init(delegate: DetailsViewModelEvents) {
        self.delegate = delegate
    }
    
    func getNutritionString() -> String {
        let nutritions = product.nutrition
        if nutritions.count == 0 {
            return "No nutritional information is available for this product."
        }
        var result = ""
        for nutri in nutritions {
            result += nutri + "\n"
        }
        return result
    }
    
    func validAmount() {
        delegate?.changeAmount(amount: amount, disableIncreaseButton: amount >= product.amount, disableDecreaseButton: amount <= 1)
    }
    
    func increaseAmount() {
        amount += 1
        validAmount()
    }
    
    func decreaseAmount() {
        amount -= 1
        validAmount()
        
    }
    
    //For enter from keyboard mode
    func changeAmount(newValue: Int) {
        if newValue > 0 && newValue <= product.amount {
            amount = newValue
            validAmount()
            return
        }
        if newValue > product.amount {
            amount = product.amount
            delegate?.changeAmountFail(message: "The number of products left is not enough", disableIncreaseButton: true, disableDecreaseButton: amount <= 1)
            return
        }
        delegate?.changeAmountFail(message: "Invalid input.", disableIncreaseButton: amount >= product.amount, disableDecreaseButton: amount <= 1)
    }
}
