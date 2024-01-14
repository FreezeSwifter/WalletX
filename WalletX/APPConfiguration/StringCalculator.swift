//
//  StringCalculator.swift
//  aibit
//
//  Created by Ian on 2023/11/9.
//

import Foundation


struct StringCalculator {

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
        case none   // 不处理
    }
    
    // 字符串计算加减乘除
    static func calculateWithRounding(decimalPlaces: Int, roundingMethod: RoundingMethod, operation: String, _ num1: String?, _ num2: String?) -> String? {
        
        let num1 = NSDecimalNumber(string: num1)
        let num2 = NSDecimalNumber(string: num2)
        
        if num1.isEqual(NSDecimalNumber.notANumber) || num2.isEqual(NSDecimalNumber.notANumber)  {
            return "NaN"
        }
        
        let number1 = num1.doubleValue
        let number2 = num2.doubleValue
        
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
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        
        switch roundingMethod {
        case .round:
            formatter.roundingMode = .halfUp
        case .ceil:
            formatter.roundingMode = .up
        case .floor:
            formatter.roundingMode = .floor
        case .none:
            formatter.roundingMode = .down
        }
        
        guard let roundedResult = formatter.string(from: NSNumber(value: result)) else {
            return nil
        }
        return roundedResult
    }
    
    // 比较两个数大小
    static func compareNumericStrings(_ str1: String?, _ str2: String?, comparisonType: ComparisonType) -> Bool {
     
        let number1 = NSDecimalNumber(string: str1)
        let number2 = NSDecimalNumber(string: str2)
        
        if number1.isEqual(NSDecimalNumber.notANumber) || number2.isEqual(NSDecimalNumber.notANumber)  {
            return false
        }
        
        let num1 = number1.doubleValue
        let num2 = number2.doubleValue
        
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
    }
    
    static func decimalPlaces(targetString: String?, decimal: Int, roundingMethod: RoundingMethod) -> String? {
        guard let string = targetString else {
            return nil
        }
        
        guard let result: Double = Double(string) else {
            return targetString
        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = decimal
        formatter.maximumFractionDigits = decimal
        
        switch roundingMethod {
        case .round:
            formatter.roundingMode = .halfUp
        case .ceil:
            formatter.roundingMode = .up
        case .floor:
            formatter.roundingMode = .floor
        case .none:
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
    
    // 保留2位小数
    func decimalPlaces(decimal: Int = 12, roundingMethod: StringCalculator.RoundingMethod = .none) -> String? {

        return StringCalculator.decimalPlaces(targetString: self, decimal: decimal, roundingMethod: roundingMethod) ?? self
    }
    
    // 分割风格的数字显示
    func separatorStyleNumber(decimal: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let doubleValue = Double(self) else {
            return self
        }
        formatter.minimumFractionDigits = decimal
        formatter.maximumFractionDigits = decimal
        formatter.usesGroupingSeparator = true
        let text = formatter.string(from: NSNumber(value: doubleValue)) ?? self
        return text
    }
    
    func absValue() -> String? {
        guard let doubleValue = Double(self) else {
            return self
        }
        return abs(doubleValue).description
    }
}
