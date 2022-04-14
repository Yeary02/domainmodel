struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ expectCurrency: String) -> Money {
        var dollar: Double
        if currency == "CAN" {
            dollar = Double(amount) / 1.25
        } else if currency == "GBP" {
            dollar = Double(amount) / 0.5
        } else if currency == "EUR" {
            dollar = Double(amount) / 1.5
        } else {
            dollar = Double(amount)
        }
        
        if expectCurrency == "CAN" {
            return Money(amount: Int(dollar * 1.25), currency: "CAN")
        } else if expectCurrency == "GBP" {
            return Money(amount: Int(dollar * 0.5), currency: "GBP")
        } else if expectCurrency == "EUR" {
            return Money(amount: Int(dollar * 1.5), currency: "EUR")
        } else {
            return Money(amount: Int(dollar), currency: "USD")
        }
    }
    
    func add(_ money: Money) -> Money {
        let newAmount: Int
        if self.currency == money.currency {
            newAmount = self.amount + money.amount
        } else {
            newAmount = money.amount + convert(money.currency).amount
        }
        
        return Money(amount: newAmount, currency: money.currency)
    }
}

class MoneyType {
    var inventory = ["USD", "GBP", "EUR", "CAN"]
    
    enum MoneyTypeError: Error {
        case InvalidCurrency
    }
    
    func mon(name: String) throws -> String {
        guard inventory.contains(name) else {
            throw MoneyTypeError.InvalidCurrency
        }
        return name
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ time: Int) -> Int {
        switch type {
        case .Hourly(let double):
            return Int(double) * time
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let double):
            type = Job.JobType.Hourly(double + byAmount)
        case .Salary(let uInt):
            type = Job.JobType.Salary(uInt + UInt(byAmount))
        }
    }

    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let double):
            type = Job.JobType.Hourly(double + byPercent * double)
        case .Salary(let uInt):
            type = Job.JobType.Salary(uInt + UInt(byPercent * Double(uInt)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? = nil
    var spouse: Person? = nil
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        if age < 18 {
            job = nil
        }
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
//    var members: [Person]
//
//    init(spouse1: Person, spouse2: Person) {
//
//    }
}
