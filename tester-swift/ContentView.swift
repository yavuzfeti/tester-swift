import SwiftUI

struct ContentView: View {
    @State private var input = "0"
    @State private var isCalculating = false

    var body: some View {
        NavigationView {
            VStack {
                Text(input)
                    .font(.system(size: 40))
                    .padding()
                
                CalculatorButtonsView(input: $input, isCalculating: $isCalculating)
            }
            .navigationBarTitle("Tester Swift")
        }
    }
}

struct CalculatorButtonsView: View {
    @Binding var input: String
    @Binding var isCalculating: Bool

    let buttonSize: CGFloat = 150
    let buttons: [[CalculatorButton]] = [
        [.digit(7), .digit(8), .digit(9), .operation(.divide)],
        [.digit(4), .digit(5), .digit(6), .operation(.multiply)],
        [.digit(1), .digit(2), .digit(3), .operation(.subtract)],
        [.operation(.clear), .digit(0), .operation(.equals), .operation(.add)],
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self)
            { 
                row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(button: button, input: $input, isCalculating: $isCalculating)
                    }
                }
            }
        }
    }
}

enum CalculatorButton: Hashable {
    case digit(Int)
    case operation(CalculatorOperation)

    var title: String {
        switch self {
        case .digit(let value):
            return String(value)
        case .operation(let operation):
            return operation.rawValue
        }
    }
}

enum CalculatorOperation: String {
    case clear = "C"
    case divide = "÷"
    case multiply = "×"
    case subtract = "-"
    case add = "+"
    case equals = "="
}

struct CalculatorButtonView: View {
    var buttonSize:Double = 30
    let button: CalculatorButton
    @Binding var input: String
    @Binding var isCalculating: Bool

    var body: some View {
        Button(action: {
            buttonTapped()
        }) {
            Text(button.title)
                .font(.system(size: 30))
                .frame(width: buttonSize, height: buttonSize)
                .background(Color.gray)
                .cornerRadius(buttonSize / 2)
        }
    }

    func buttonTapped() {
        switch button {
        case .digit(let value):
            if isCalculating {
                input = String(value)
                isCalculating = false
            } else {
                input += String(value)
            }
        case .operation(let operation):
            if operation == .clear {
                input = "0"
            } else if operation == .equals {
                performCalculation()
            } else {
                isCalculating = true
                input += operation.rawValue
            }
        }
    }

    func performCalculation() {
        let expression = NSExpression(format: input)
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            input = String(result)
        } else {
            input = "Error"
        }
        isCalculating = false
    }
}
