import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init (name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

typealias VendingMachineProducts = [VendingMachineProduct]

extension VendingMachineProducts {
    static func examples() -> VendingMachineProducts {
        return [
            VendingMachineProduct(name: "Produto 1", amount: 3, price: 10.0),
            VendingMachineProduct(name: "Produto 2", amount: 4, price: 30.0),
            VendingMachineProduct(name: "Produto 3", amount: 2, price: 90.0),
            VendingMachineProduct(name: "Produto 4", amount: 2, price: 5.0),
        ]
    }
}


enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insufficientFunds
    case productStuck
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Não temos esse produto"
        case .productUnavailable:
            return "Não temos esse produto no stock"
        case .insufficientFunds:
            return "O dinheiro é insuficiente"
        case .productStuck:
            return "Infelizmente tivemos um problema com a entrega do seu produto"
        }
    }
}
//TODO: Definir os erros

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        
        //TODO: receber o dinheiro e salvar em uma variável
        self.money += money
        
        //TODO: achar o produto que o cliente quer
        guard let produto = estoque.first(where: { $0.name == name }) else {
            throw VendingMachineError.productNotFound
        }
        
        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else {
            throw VendingMachineError.productUnavailable
        }
                
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price <= money else {
            throw VendingMachineError.insufficientFunds
        }
        //TODO: entregar o produto
        guard Int.random(in: 0...100) > 3 else {
            throw VendingMachineError.productStuck
        }
        self.money -= produto.price
        produto.amount -= 1
        
    }
    
    func getTroco() -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        let money = self.money
        self.money = 0
        return money
    }
}

let machine = VendingMachine(products: VendingMachineProducts.examples())

if let mac = try? machine.getProduct(named: "Produto 1", with: 100) {
    
}

do {
    try machine.getProduct(named: "Produto 1", with: 100)
    try machine.getTroco()
    try machine.getProduct(named: "Produto 2", with: 100)
    try machine.getTroco()
} catch {
    print(error.localizedDescription)
}
