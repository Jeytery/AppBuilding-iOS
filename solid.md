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

В данном случае пример не идеален, идея SR развивается и на сам контроллер. Сам по себе он должен работать только с юаем данного окна 
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
Не нужно кастылить что-то. [Пример](xcode-examples/SOLID/OpenClose)


### Liskov
### Interface Segregation
### Dependency Inversion
