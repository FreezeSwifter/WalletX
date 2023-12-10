//
//  StringCalculator.swift
//  aibit
//
//  Created by W.H.Y on 2023/11/9.
//

import Foundation


struct StringCalculator {
    
    private static let formatter = NumberFormatter()
    
    enum ComparisonType {
        case less               // 小于
        case lessOrEqual        // 小于等于
        case equal              // 等于
        case greater            // 大于
        case greaterOrEqual     // 大于等于
    }
    
    enum RoundingMethod {
        case round  // 四舍五入
        case ceil   // 向上取整
        case floor  // 向下取整
    }
    
    // 字符串计算加减乘除
    static func calculateWithRounding(decimalPlaces: Int, roundingMethod: RoundingMethod, operation: String, _ num1: String?, _ num2: String?) -> String? {
        guard let num1 = num1, let num2 = num2 else {
            return nil
        }
        guard let number1 = Double(num1), let number2 = Double(num2) else {
            return nil
        }
        
        var result: Double = 0.0
        switch operation {
        case "+":
            result = number1 + number2
        case "-":
            result = number1 - number2
        case "*":
            result = number1 * number2
        case "/":
            result = number1 / number2
        default:
            return nil
        }
        
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        formatter.roundingMode = .down
        switch roundingMethod {
        case .round:
            formatter.roundingMode = .halfUp
        case .ceil:
            formatter.roundingMode = .up
        case .floor:
            formatter.roundingMode = .down
        }
        
        guard let roundedResult = formatter.string(from: NSNumber(value: result)) else {
            return nil
        }
        return roundedResult
    }
    
    // 比较两个数大小
    static func compareNumericStrings(_ str1: String?, _ str2: String?, comparisonType: ComparisonType) -> Bool {
        guard let str1 = str1, let str2 = str2 else {
            return false
        }
        
        if let num1 = Double(str1), let num2 = Double(str2) {
            switch comparisonType {
            case .less:
                return num1 < num2
            case .lessOrEqual:
                return num1 <= num2
            case .equal:
                return num1 == num2
            case .greater:
                return num1 > num2
            case .greaterOrEqual:
                return num1 >= num2
            }
        } else if let int1 = Int(str1), let int2 = Int(str2) {
            switch comparisonType {
            case .less:
                return int1 < int2
            case .lessOrEqual:
                return int1 <= int2
            case .equal:
                return int1 == int2
            case .greater:
                return int1 > int2
            case .greaterOrEqual:
                return int1 >= int2
            }
        }
        return false
    }
    
    static func decimalPlaces(targetString: String?, decimal: Int, roundingMethod: RoundingMethod) -> String? {
        guard let string = targetString else {
            return nil
        }
        
        guard let result: Double = Double(string) else {
            return targetString
        }
        formatter.minimumFractionDigits = decimal
        formatter.maximumFractionDigits = decimal
        formatter.roundingMode = .down
        switch roundingMethod {
        case .round:
            formatter.roundingMode = .halfUp
        case .ceil:
            formatter.roundingMode = .up
        case .floor:
            formatter.roundingMode = .down
        }
        guard let roundedResult = formatter.string(from: NSNumber(value: result)) else {
            return nil
        }
        return roundedResult
    }
}



// 乘除运算优先级高于加减
precedencegroup PowerPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}
// 乘除
infix operator ~* : PowerPrecedence
infix operator ~/ : PowerPrecedence
// 加减
infix operator ~+ : AdditionPrecedence
infix operator ~- : AdditionPrecedence
// 比较大小
infix operator ~> : AdditionPrecedence
infix operator ~>= : AdditionPrecedence
infix operator ~== : AdditionPrecedence
infix operator ~< : AdditionPrecedence
infix operator ~<= : AdditionPrecedence

func ~* (lhs: String?, rhs: String?) -> String? {
    return StringCalculator.calculateWithRounding(decimalPlaces: 12, roundingMethod: .floor, operation: "*", lhs, rhs)
}

func ~/ (lhs: String?, rhs: String?) -> String? {
    return StringCalculator.calculateWithRounding(decimalPlaces: 12, roundingMethod: .floor, operation: "/", lhs, rhs)
}

func ~+ (lhs: String?, rhs: String?) -> String? {
    return StringCalculator.calculateWithRounding(decimalPlaces: 12, roundingMethod: .floor, operation: "+", lhs, rhs)
}

func ~- (lhs: String?, rhs: String?) -> String? {
    return StringCalculator.calculateWithRounding(decimalPlaces: 12, roundingMethod: .floor, operation: "-", lhs, rhs)
}

func ~> (lhs: String?, rhs: String?) -> Bool {
    return StringCalculator.compareNumericStrings(lhs, rhs, comparisonType: .greater)
}

func ~>= (lhs: String?, rhs: String?) -> Bool {
    return StringCalculator.compareNumericStrings(lhs, rhs, comparisonType: .greaterOrEqual)
}

func ~== (lhs: String?, rhs: String?) -> Bool {
    return StringCalculator.compareNumericStrings(lhs, rhs, comparisonType: .equal)
}

func ~< (lhs: String?, rhs: String?) -> Bool {
    return StringCalculator.compareNumericStrings(lhs, rhs, comparisonType: .less)
}

func ~<= (lhs: String?, rhs: String?) -> Bool {
    return StringCalculator.compareNumericStrings(lhs, rhs, comparisonType: .lessOrEqual)
}

extension String {
    
    // 获取颜色
    func fetchColor() -> UIColor {
        let res = StringCalculator.compareNumericStrings(self, "0", comparisonType: .greater)
        if res  {
            return UIColor.upColor
        } else {
            return UIColor.downColor
        }
    }
    
    // 保留2位小数
    func decimalPlaces(decimal: Int, roundingMethod: StringCalculator.RoundingMethod = .floor) -> String? {
        return StringCalculator.decimalPlaces(targetString: self, decimal: decimal, roundingMethod: roundingMethod) ?? self
    }
}
