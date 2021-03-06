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
        let inventory = ["USD", "GBP", "EUR", "CAN"]
        guard inventory.contains(expectCurrency) else {
            return Money(amount: -1, currency: "Unknown Currency")
        }
        
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
    
    func subtract(_ money: Money) -> Money {
        let newAmount: Int
        if self.currency == money.currency {
            newAmount = self.amount - money.amount
        } else {
            newAmount = money.amount - convert(money.currency).amount
        }
        
        return Money(amount: newAmount, currency: money.currency)
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
            return Int(double * Double(time))
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
    let firstName: String
    let lastName: String
    let age: Int
    var _job: Job?
    var job: Job? {
        get { return self._job }
        set {
            if age < 18 {
                _job = nil
            } else {
                _job = newValue
            }
        }
    }
    var _spouse: Person?
    var spouse: Person? {
        get { return self._spouse }
        set {
            if age < 21 {
                _spouse = nil
            } else {
                _spouse = newValue
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String {
        return String("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title) spouse:\(spouse?.firstName)]")
    }
}

//////////////////////////////
// Family
//
public class Family {
    var members: [Person]

    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        } else {
            members = []
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if members[0].age < 21 || members[1].age < 21 {
            return false
        } else {
            members.append(child)
            return true
        }
    }
    
    func householdIncome() -> Int {
        var total = 0
        for person in members {
            total += person.job?.calculateIncome(2000) ?? 0
            print(total)
        }
        return total
    }
}
