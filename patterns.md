# Patterns 

- [Responder Chain](#chain-of-responsobility)
- [Adapter](#adapter)
- [Command](#command)
- [Facade](#facade)
- [Composite](#composite)
- [Template Methods](#template-methods)
- [Singleton](#singleton)
- [Delegate](#delegate)

### Chain Of Responsobility
Как видно из названия наша задача создать чейн - для этого будет использоваться псевдорекурсия в класах
Используем переменную внутри класса этого же типа. Основной посыл в том, что если класс А несправился, он делегирует задачу на другой. 
Другой не справился? Делегируем по чейну опять и так до бесконечности

Пример концетуального кода: 
``` swift
final class Responder {
    private var qa: [String: String]
    private var next: Responder?

    init(qa: [String: String]) {
        self.qa = qa
    }

    func setNext(_ next: Responder) {
        self.next = next
    }

    func answer(for question: String) -> String {
        if let answer = qa[question] {
            print("--- Done.")
            return answer
        } else if let next = next {
            print("--- Can't handle. Processing to the next...")
            return next.answer(for: question)
        }
        print("--- No answer")
        return "Sorry! We'll call you later"
    }
}
``` 
Это основной юнит для нашего паттерна. Есть работа с ответами на вопросы + делегирование задачи на следующего юнита по чейну. 
Тот тоже будет иметь в себе чейн на следующего юнита, если не справиться делегирует ему(если мы его ему установим само собой).
Так будет происходить до бесконечности \

Посмотрим на использование 
``` swift
final class CallCenter {
    private var answerPhone: Responder
    private var manager: Responder
    private var expert: Responder

    init(answerPhone: Responder, manager: Responder, expert: Responder) {
        self.answerPhone = answerPhone
        self.manager = manager
        self.expert = expert
    }

    func receiveCall(question: String) {
        print("Answer: \(answerPhone.answer(for: question))")
    }
}

let answerPhone = Responder(qa: [
    "How to turn it on?": "Push the green button",
    "How to turn it off?": "Push the red button"
])
let manager = Responder(qa: ["I wanna refresh profile info": "Let's get on with it"])
let expert = Responder(qa: ["Very specific tech question": "Specific answer"])

answerPhone.setNext(manager)
manager.setNext(expert)

let callCenter = CallCenter(answerPhone: answerPhone, manager: manager, expert: expert)
callCenter.receiveCall(question: "Very specific tech question")
```

CallCenter в данном случае не обязателен, просто обертка небольшая автором репы из source.
Что происходит по итогу \
Закидываем вопрос в callCenter -> его обрабатывает manager -> не может ответить -> делегирует вопрос на expert -> обрабатывает -> выдает ответ \
Тут было два варианта: expert тожу не смог ответить - выход из чейна с пометка "Извните, мы не знаем ответ на Ваш вопрос, все в чейне поптылись его обработать, но никто не смог". Можем добавить в один из Responeder-ов новые кейсы или же создать нового респондера и присвоить его как nextResponder для expert. Можно создать их бесконечно много и захендлить вообще все что угодно

```
output:
--- Can't handle. Processing to the next...
--- Can't handle. Processing to the next...
--- Done.
Answer: Specific answer
```
два Can't handle - callPhone и manager не смогли. Done - expert смог ответить на вопрос, дальше сам ответ


### Adapter
Разная реализация, одного и того же протокола. 

``` swift
protocol Drawer {
    func drawTriangle()
}

class OpenGLDrawer: Drawer {
    func drawTriangle() {
        // openGL realization 
    }
}

class VulkanDrawer: Drawer {
    func drawTriangle() {
        // vulkan realization
    }
}

class MetalDrawer: Drawer {
    func drawTriangle() {
        // metal realization  
    }
}

class DirectXDrawer: Drawer {
    func drawTriangle() {
        // directX realization  
    }
}
```
Пример - разная реализция 'hello world' из мира графических апи. В реальности все это сложнее и просиходит совсем по-другому, это просто пример
Есть базовый протокол, у которого разные реализации рисования треугольника. Четыре графических апи реализуют его по своему

``` swift 
class UIKit {
    
    private let drawer: Drawer

    init(drawer: Drawer) {
        self.drawer = drawer
    }

    func createSomePicture() {
        // user drawer api to create something crazy cool 
    }

    func createSomethingWithDrawerHelp() {
        // also 
    }
}

let drawer = MetalDrawer()
let uiKit = UIKit(drawer: drawer)
uiKit.createSomePicture()
```
Класс инжектит этот функционал в себя - более того, он может получать любого, кто реализует протокол Drawer. 
Поэтому мы можем менять релизацию рисования треугльника когда захотим. В примере из сорсов работа с вычислениями - принцип тот же 

### Command 
Есть протокол Command с одним методом execute(). Есть класс, в нем храним реализации этих протоколов в массиве и методом старт через forEach вызываем методом execute()

### Facade 
Система использует подсистему. 

```Концептуальный пример```

```swift 
class Facade {

    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2

    init(
        subsystem1: Subsystem1 = Subsystem1(),
        subsystem2: Subsystem2 = Subsystem2()
    ) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }

    func operation() -> String {
        // some functional with help of two subsystems 
    }
}
```
В данном случае что такое сабситемы это не важно. Это может быть все что угодно, что дает нам какой-то функионал. 
Такой подход использует SnapKit, KingFisher

```Реальный пример в iOS```
```swift 
private class ImageDownloader {
    typealias Completion = (UIImage, Error?) -> ()
    typealias Progress = (Int, Int) -> ()

    func loadImage(
        at url: URL?,
        placeholder: UIImage? = nil,
        progress: Progress? = nil,
        completion: Completion
    ) {
        /// ... Set up a network stack
        /// ... Downloading an image
        /// ...
        completion(UIImage(), nil)
    }
}

private extension UIImageView {
    func downloadImage(at url: URL?) {
        print("Start downloading...")
        let placeholder = UIImage(named: "placeholder")

        ImageDownloader().loadImage(
            at: url,
            placeholder: placeholder
        ) { image, error in
            /// Crop, cache, apply filters, whatever...
            self.image = image
        })
    }
}
```
В экстеншине мы используем сабсистем загрузки фото. Сделаем сабсистем которая хранит ее в userDefault - получим еще одну сабсистем.
Экстеншин в данном случае фасад 

### Composite

https://refactoring.guru/design-patterns/composite/swift/example#example-1 <- Клевый реальный пример использование для UIKit
Работа примерно как в игровом движке Unity. Встраиваем компоненты в UIView и UIViewController. 
У каждого компонента есть метод accept и структура с входными данными (Theme). 
Для отдельных UIView структура Theme может разной, только она должна наследываться от базовой Theme. 
В applу реализуем нужный нам функционал, в примере - стиль кнопкок, лейблов итд. 
Можем использовать теперь разные стили для кнопок, вью или вообще контроллеров

Мой реальный пример в приложении - [click](xcode-examples/Patterns/Composite)

### Template Methods
``` swift 
class DataSaver {

    func extractData() {
        print("Extracting data...")
    }
    
    func parseData() {
        print("Parsing data...")
    }
    
    func processData() {
        print("Processing data...")
    }

    func openResource() {
        fatalError("openResource() must be overrided")
    }

    func closeResource() {
        fatalError("closeResource() must be overrided")
    }

    func operation() {
        extractData()
        parseData()
        processData()

        openResource() 
        closeResource()
    }
}

class UserDefaultsSaver: DataSaver {
    override func openResource() {
        // realization
    }

    override func closeResource() {
        // realization
    }
}

class CoreDataSaver: DataSaver {
    override func openResource() {
        // realization
    }

    override func closeResource() {
        // realization
    }
}

class RealmDataSaver: DataSaver {
    override func openResource() {
        // realization
    }

    override func closeResource() {
        // realization
    }
}

let dataSaver = RealmDataSaver()
dataSaver.operation()
```
Есть класс, который дает базовое использование методов. Наследники, которые по своему реализуют его дают разные функционал. 
Легко заменяется адаптером, стартегией 

### Singleton
Класс с одим экземляром 
```swift
class API {

    private init() {}

    static let shared = API()
    
    func getSomething() -> Int {
        return 1
    }
}
API.shared.getSomething()
```
### Delegate 
Похож на адаптер, но немного в другой форме. 
```swift 
struct User {
    let name: String
    let age: Int
}

protocol UsersViewControllerDelegate: AnyObject {
    func userViewController(_ viewController: UsersViewController, didChoose user: User)
}

class UsersViewController: UIViewController {
    
    weak var delegate: UsersViewControllerDelegate?

    private let tableView = UITableView()
    private var users: [Users] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup tableView
        // fetch users
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectAt indexPath: IndexPath) {
        delegate?.userViewController(self, didChoose: users[indexPath.row])
    }
}   
```
Можем как и в адаптере передавать в конструктор класса - но в основном используется как опциональная переменная. Извне присвоили ей реализацию - появился функционал. Ниже пример

``` swift 
class SomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UserViewController() 
        vc.delegate = self 
        self.present(vc)
    }
}

extension SomeViewController: UserViewControllerDelegate {
    func userViewController(_ viewController: UsersViewController, didChoose user: User) {
        viewController.dismiss()
        print(user)
    }
}
```
Когда будет выбран юзер, сработает метод didChoose user. У юайкитового UITableView переменные delegate и dataSource это тоже паттерны делегат


### sources
https://github.com/artkirillov/DesignPatterns примеры в коде \
https://refactoring.guru/design-patterns/ примеры и вкоде и вообще все
