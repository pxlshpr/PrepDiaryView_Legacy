import Foundation
import PrepDataTypes

//MARK: - Model Extensions (To be rewritten)

extension FoodItem {
    var isCompleted: Bool {
        markedAsEatenAt != nil
    }
    
    func amountString(withDetails: Bool, parentMultiplier: Double = 1.0) -> String {
        return "amountString(…)"
//        let amount = itemAmount * parentMultiplier
//
//        if let size = amountSize, let _ = size.amountSize {
//            return size.description(with: amount)
//        }
//
//        let description: String?
//        switch amountUnitType {
//        case .weight:
//            description = amountWeightUnit?.shortDescription(with: amount)
//        case .volume:
//            description = amountVolumeUnit?.shortDescription(with: amount)
//        case .serving:
//            description = "serving".with(amount: amount)
//        case .size:
//            description = amountSize?.description(with: amount, sizeVolumeUserUnit: amountSizeVolumeUserUnit)
//        }
//        return description ?? "unknown unit"
    }
}

extension FoodItem {
    var energyAmount: Double {
        food.energy(for: self)
    }
}
extension Meal {
    var isNextPlannedMeal: Bool {
        return false
//        guard let day = day,
//              day.isToday,
//              let nextPlannedMeal = day.nextPlannedMeal else {
//            return false
//        }
//        return nextPlannedMeal.id == id
    }
    
    var isCompleted: Bool {
        markedAsEatenAt != nil
    }
    
    var energyAmount: Double {
        foodItems.reduce(0) { $0 + $1.energyAmount }
    }
    
    var timeString: String {
        Date(timeIntervalSince1970: time).formatted(date: .omitted, time: .shortened).lowercased()
    }
    
//    var timeDate: Date {
//        get { Date(timeIntervalSince1970: TimeInterval(time)) }
//        set { time = Int64(newValue.timeIntervalSince1970) }
//    }

}

extension Food {
    func scaledValue(_ value: Double, for foodItem: FoodItem) -> Double {
        multiplier(for: foodItem) * value
    }
    
    func energy(for item: FoodItem) -> Double {
        if let childrenFoods {
            return scaledValue(childrenFoods.reduce(0) { $0 + $1.energyAmount }, for: item)
        } else {
            return scaledValue(energy, for: item)
        }
    }
}

extension Food {
    func multiplier(for foodItem: FoodItem) -> Double {
        0
//        if let size = item.amountSize {
//            //scale amount first, if we happen to have a sizeVolumeUserUnit, so if we say 1 cup, and the size is 1 cup, the scaledAmount is 1, but if we say 1000 mL and the size is 1 cup, the scaledAmount is 1000/240 = 4.1667 (cups, essentially), and use that in the following—if we don't have it, simply set it to item.amount
//            var amount = item.itemAmount
//            if let amountVolumeUserUnit = item.amountSizeVolumeUserUnit,
//               let sizeVolumeUserUnit = size.nameVolumeUserUnit
//            {
//                amount = (amountVolumeUserUnit.ml/sizeVolumeUserUnit.ml) * amount
//            }
//
//            switch size.baseUnitType {
//            case .weight:
//                return amount * size.baseWeightInGrams * weightMultiplier(for: .g)
//            case .volume:
//                return amount * size.baseVolumeInMilliliters * volumeMultiplier(for: VolumeUnit.mL.volumeUserUnit)
//            case .serving:
//                return amount * size.baseServings * servingMultiplier
//            default:
//                return 0
//            }
//        } else if let volumeUserUnit = item.amountVolumeUserUnit {
//            return item.itemAmount * volumeMultiplier(for: volumeUserUnit)
//        } else if let weightUnit = item.amountWeightUnit {
//            return item.itemAmount * weightMultiplier(for: weightUnit)
//        } else {
//            guard item.amountUnitType == .serving else { return 0 }
//            return item.itemAmount * servingMultiplier
//        }
    }

//    func volumeMultiplier(for volumeUserUnit: VolumeUserUnit) -> Double {
//        /// first determine the multiplier for the food in terms of 1 mL
//        var multiplier = volumeMultiplier
//
//        /// now scale the multiplier given the weightUnit provided
//        multiplier = multiplier / (1.0/volumeUserUnit.ml)
//        return multiplier
//    }
//
//    func weightMultiplier(for weightUnit: WeightUnit) -> Double {
//        /// first determine the multiplier for the food in terms of 1 gram
//        var multiplier = weightMultiplier
//
//        /// now scale the multiplier given the weightUnit provided
//        multiplier = multiplier / (1.0/weightUnit.g)
//        return multiplier
//    }
//
//    /**
//     Returns the multiplier for the food in terms of 1 gram.
//
//     If the food is described in terms of a size—then its raw weight is used to calculate this.
//
//     If the food is described in terms of a volume or volume based size—then its converted (assuming we have a density).
//     */
//    var volumeMultiplier: Double {
//
//        func multiplierFor(milliliters: Double, amount: Double) -> Double {
//            guard milliliters > 0, amount > 0 else { return 0 }
//            return 1.0/(milliliters * amount)
//        }
//
//        func multiplierFor(volumeUserUnit: VolumeUserUnit?, amount: Double) -> Double {
//            guard let volumeUserUnit = volumeUserUnit, amount > 0 else { return 0 }
//            return multiplierFor(milliliters: volumeUserUnit.ml, amount: amount)
//        }
//
//        func multiplierFor(weightUnit: WeightUnit?, amount: Double) -> Double {
//            guard let weightUnit = weightUnit,
//                  let densitySize = densitySize else { return 0 }
//            let milliliters = densitySize.convertToMilliliters(grams: weightUnit.g)
//            return multiplierFor(milliliters: milliliters, amount: amount)
//        }
//
//        func multiplierFor(volumeBasedSize: FoodSize?, amount: Double) -> Double {
//            guard let size = volumeBasedSize else { return 0 }
//            return multiplierFor(milliliters: size.baseVolumeInMilliliters, amount: amount)
//        }
//
//        func multiplierFor(weightBasedSize: FoodSize?, amount: Double) -> Double {
//            guard let size = weightBasedSize,
//                  let densitySize = densitySize else { return 0 }
//            let milliliters = densitySize.convertToGrams(milliliters: size.baseWeightInGrams)
//            return multiplierFor(milliliters: milliliters, amount: amount)
//        }
//
//        switch foodUnitType {
//        case .weight:
//            return multiplierFor(weightUnit: amountWeightUnit, amount: amount)
//        case .weightBasedSize:
//            return multiplierFor(weightBasedSize: amountSize, amount: amount)
//        case .servingWithWeight:
//            return multiplierFor(weightUnit: servingWeightUnit, amount: servingAmount)
//        case .servingWithWeightBasedSize:
//            return multiplierFor(weightBasedSize: servingSize, amount: servingAmount)
//        case .volume:
//            return multiplierFor(volumeUserUnit: amountVolumeUserUnit, amount: amount)
//        case .volumeBasedSize:
//            return multiplierFor(volumeBasedSize: amountSize, amount: amount)
//        case .servingWithVolume:
//            return multiplierFor(volumeUserUnit: servingVolumeUserUnit, amount: servingAmount)
//        case .servingWithVolumeBasedSize:
//            return multiplierFor(volumeBasedSize: servingSize, amount: trueServingAmount)
//        case .servingWithServingBasedSize:
//            return 0
//        default:
//            return 0
//        }
//    }
//
//    /**
//     Returns the multiplier for the food in terms of 1 gram.
//
//     If the food is described in terms of a size—then its raw weight is used to calculate this.
//
//     If the food is described in terms of a volume or volume based size—then its converted (assuming we have a density).
//     */
//    var weightMultiplier: Double {
//
//        func multiplierFor(grams: Double, amount: Double) -> Double {
//            guard grams > 0, amount > 0 else { return 0 }
//            return 1.0/(grams * amount)
//        }
//
//        func multiplierFor(weightUnit: WeightUnit?, amount: Double) -> Double {
//            guard let weightUnit = weightUnit else { return 0 }
//            return multiplierFor(grams: weightUnit.g, amount: amount)
//        }
//
//        func multiplierFor(volumeUserUnit: VolumeUserUnit?, amount: Double) -> Double {
//            guard let volumeUserUnit = volumeUserUnit,
//                  let densitySize = densitySize else { return 0 }
//            let grams = densitySize.convertToGrams(milliliters: volumeUserUnit.ml)
//            return multiplierFor(grams: grams, amount: amount)
//        }
//
//        func multiplierFor(weightBasedSize: FoodSize?, amount: Double) -> Double {
//            guard let size = weightBasedSize else { return 0 }
//            return multiplierFor(grams: size.baseWeightInGrams, amount: amount)
//        }
//
//        func multiplierFor(volumeBasedSize: FoodSize?, amount: Double) -> Double {
//            guard let size = volumeBasedSize,
//                  let densitySize = densitySize else { return 0 }
//            let grams = densitySize.convertToGrams(milliliters: size.baseVolumeInMilliliters)
//            return multiplierFor(grams: grams, amount: amount)
//        }
//
//        switch foodUnitType {
//        case .weight:
//            return multiplierFor(weightUnit: amountWeightUnit, amount: amount)
//        case .weightBasedSize:
//            return multiplierFor(weightBasedSize: amountSize, amount: amount)
//        case .servingWithWeight:
//            return multiplierFor(weightUnit: servingWeightUnit, amount: servingAmount)
//        case .servingWithWeightBasedSize:
//            return multiplierFor(weightBasedSize: servingSize, amount: trueServingAmount)
//        case .volume:
//            return multiplierFor(volumeUserUnit: amountVolumeUserUnit, amount: amount)
//        case .volumeBasedSize:
//            return multiplierFor(volumeBasedSize: amountSize, amount: amount)
//        case .servingWithVolume:
//            return multiplierFor(volumeUserUnit: servingVolumeUserUnit, amount: trueServingAmount)
//        case .servingWithVolumeBasedSize:
//            return multiplierFor(volumeBasedSize: servingSize, amount: trueServingAmount)
//        case .servingWithServingBasedSize:
//            return 0
//        default:
//            return 0
//        }
//    }
//
//    /**
//     Returns how many servings equate to the nutrients of this food
//
//     Since the serving size is described in the `amount` field—a value of 1 indicates that the nutrients are per 1 serving, while a value of 0.5, indicates that that its per 0.5 servings. So we would return `1/amount`—which would result in a food describing its nutrients per 0.5 servings, returning a multiplier of 2x so that all values are multiplied by 2.
//
//     The `servingAmount` is irrelevant here, as we're not concerned about the actual size of a measurement when returning its multiplier.
//     */
//    var servingMultiplier: Double {
//        guard amount != 0 else { return 0 }
//        return 1.0/amount
//    }
}

extension Food {

    var energy: Double {
        0
    }
    
    var energyAmount: Double {
        if let childrenFoods {
            return childrenFoods.reduce(0) { $0 + $1.energyAmount }
        } else {
            return scaledAmount(from: energy)
        }
    }
    
    func scaledAmount(from amount: Double) -> Double {
        return 0
//        if servingAmount > 0, self.amount > 0 {
//            return amount/self.amount
//        } else {
//            return amount
//        }
    }

}

//MARK: - Reusable

import SwiftUI

struct ListRowBackground: View {
    
    @State var color: Color = .clear
    @State var includeTopSeparator: Bool = false
    @State var includeBottomSeparator: Bool = false
    
    var body: some View {
        ZStack {
            color
            VStack(spacing: 0) {
                if includeTopSeparator {
                    separator
                }
                Spacer()
                if includeBottomSeparator {
                    separator
                }
            }
        }
    }
    
    var separator: some View {
        Rectangle()
            .frame(height: 0.18)
            .background(Color(.separator))
            .opacity(0.225)
    }
}

