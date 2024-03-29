# SOLID

- [S - Single Responsibility](#single-responsibility)
- [O - Open/Close](#open-close)
- [L - Liskov](#liskov)
- [I - Interface Segregation](#interface-segregation)
- [D - Dependency Iversion](#dependency-inversion)

### Single Responsibility
Буквально из названия - сущность отвечает только за одно определенное действие

```swift 
class ViewController: UIViewController {

    private let networkService: NetworkServiceTarget

    init(_ networkService: NetworkServiceTarget) {
        self.networkService = networkService
    }

    required init(...args) {
        fatalError()
    }

    func fetchData() {
        networkService.getSomeData() {
            [weak self] data in 
            // ... 
        }
    }
}
```
Контроллер не должен брать нетворкинг на себя и реализовывать его. Этим должнен заниматься кто-то другой

В данном случае пример не идеален, идея SR развивается и на сам контроллер. Сам по себе он должен работать только с юаем данного окна \
\
Посмотрим пример 

```swift 
protocol UsersViewControllerEventOutput: AnyObject {
    func viewControllerDidTapButton1()
    func viewControllerDidTapButton2()
}

protocol UsersViewControllerInput {
    func displayData(data: Data)
}

class UsersViewController: UIViewController {

    weak var eventOutput: ViewControllerEventOutput?

    private let businessLogic: UsersBusinessLogic

    init(_ businessLogic: UsersBusinessLogic) {
        self.businessLogic = businessLogic 
        self.eventOutput = businessLogic
        businessLogic.viewInput = self 
    }

    required init(...args) {
        fatalError()
    }
}

extension UsersViewController: UsersViewControllerInput {
    func displayData(data: Data) {
        // some ui code 
        // for example: 
        displayDataInTableView(data: data)
    }
}
```

BusinessLogic будет иметь доступ к ивентам контролера и его юай функциям (displayData тут). По SR мы разделили работу окна на две сущности - одна отвечает за юай, вторая за логику. Идею можно развивать до бесконечности. Из-за этого на свет появился VIPER - он разделяет в окне или же кусочке юая все еще сильнее

### Open Close
Ентити открыт только для расширения, модификация запрещена. \
Когда ты можешь в любой момент добавить новый пункт в меню. 
Не нужно кастылить что-то. [Пример](xcode-examples/SOLID/OpenClose) \
\
Еще один пример:
``` swift 
enum NotCleanEnum {
    case value1
    case value2
    case value3
    
    var body: String {
        switch self {
            case .value1: return "1"
            case .value2: return "2"
            case .value3: return "3"
        }
    }
    
     var body2: String {
        switch self {
            case .value1: return "1.1"
            case .value2: return "2.2"
            case .value3: return "3.3"
        }
    } 
}

struct CleanEnum {
    let body: String
    let body2: String
    
    static let value1 = CleanEnum(body: "1", body2: "1.1")
    static let value2 = CleanEnum(body: "2", body2: "2.2")
}

```
Добавление новых кейсов в первом случае заставит переделывать свичи. Во втором - нет. Правда все равно сломается если вдруг вам понадобиться добавить 
новое свойство. НО можно и это решить
```swift 
struct SuperCleanEnum {
    enum DataKey: String, Hashable {
        case data1 = "data1"
        case data2 = "data2"
        case data3 = "data3"
    }
    
    let data: [DataKey: Any]
    
    static let case1 = SuperCleanEnum(
        data: [.data1: 5, .data2: "i super very love fucking SOLID", .data3: CleanEnum.value2]
    )
    
    static let case2 = SuperCleanEnum(
        data: [.data1: 5, .data2: "i super very love fucking SOLID"]
    )
    
    static let case3 =  SuperCleanEnum(
        data: [.data1: 5, .data3: CleanEnum.value1]
    )
}
```
Опен Клоуз - это конечно же мечта. Но в реальности продумать все сходу и сразу - невозможно

### Liskov
Замена наследников протокола не должна приводить к неожиданных последсвиям в программе. \
Пример 

```не клин```
```swift 
protocol AnimalLoader {
    func loadAnimals(_ callback: @escaping (Result<Any, Error>) -> Void)
}

class UserDefaultsAnimalLoader: AnimalLoader {
    func loadAnimals(_ callback: @escaping (Result<Any, Error>) -> Void) {
        if let animals = UserDefualts.standard.stringArray(forKey: "animals") {
            callback(.success(animals))
        } 
        else {
            calback(.failure(NoAnimals()))
        }
    }
}

```
Не клин чисто потому что у нас протокол AnimalLoader в коллбэк может передать вообще все что угодно. Там может быть как энималы так и инты \
Клином будет помнять Any в коллбэке на [String] - у нас будет всегда один и тот же результат от всех наследников AnimalLoader \
\
```второй не клин```

```swift 
class UserDefaultsAnimalLoader: AnimalLoader {
    func loadAnimals(_ callback: @escaping (Result<Any, Error>) -> Void) {
        if let animals = UserDefualts.standard.stringArray(forKey: "animals") {
            callback(.success(animals))
        } 
        else {
            print("No animals")
        }
    }
}
```
Не использовать Error, тот кто возпользуется этой реализацией протокола будет ожидать что может получить ошибку и напишет вокруг нее логику.
Не очень-то красиво не уведомить его об ошибке, которую обещали кинуть.

### Interface Segregation
Общие протоколы - плохо. Фукнционал, который сущность не использует - плохо. Разделяй и властвуй. 
``` swift 
protocol Hashable {}
protocol Equitable {}
protocol Comparable {}
```
Свифт лучший представитель правлиа IS. Все его типы это набор протоколов и мы можем очень гибко использовать их в разных местах \
\
```как было в objective-c```
``` swift 
public protocol NSObjectProtocol {
    func isEqual(_ object: Any?) -> Bool
    var hash: Int { get }
}
```
Не очень гибко, в свифте можно быть только Equitable или Hashable или вместе если того требуют обстоятельства. Гибко? Гибко \
\
В UIKit этот подход можно встретить в UITableView. Переменные delegate и dataSource это буквально IS во плоти. Каждый отвечает за свое. 
```swift 
class UITableView: UIView {
    weak var delegate: UITableViewDelegate?
    weak var dataSource: UITableViewDataSource
}
```
\
Как бы использовать? Вот

```swift 
protocol MyViewControllerEventOutput: AnyObject {
    func myViewController(didTap button1: UIButton)
    func myViewController(didTap button2: UIButton)
    func myViewController(didTap button3: UIButton)
}

protocol MyViewControllerDelegate: AnyObject {
    func myViewController(didEndWorkWith data: Data)    
}

class MyViewController: UIViewController {
    weak var delegate: MyViewControllerDelegate?
    weak var eventOutput: MyViewControllerEventOutput?
}
```
Разделили общие ивенты и ивенты для уведомление о состояних контроллера в разные протоколы. 
На первый можно подписывать презентеры, на второй - тех, кто отвечает за навигацию

### Dependency Inversion
Более высокие модули не должны зависить от нижних. По факту это можно добиться только тем, что мы используем стабильные нижнии модули.
В DIP проблема не сможет уйти если мы просто будет передавать какую-то реализацию протокола в модуль. Это даст только возможность 
подменять реализацию. Если мы изменим протокол, все все равно нужно будет переделывать. Поинт в том, что мы все еще передаем все через протокол или даже
передаем класс с паблик полями, но гарантируем, что "публичное апи" этого класса не будет меняться. Стабильный интерфейс, который не меняется или же просто класс, который имеет паблик поля это не так важно, главное что они всегда будут такими

