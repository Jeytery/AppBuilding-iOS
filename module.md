Модуль Вашего приложения должен быть гибок. Используете ли вы VIPER или MVVМ это не важно.
Следующий цели, которые должны достигаться модулем

- полная независимость от проектных слоев  
    Модуль должен иметь интерфесы для взаимодействия с собой. Это нужно чтобы использовать его где-угодно
    
- разбираемость на кусочки  
    Часть модуля должны быть сделаны так, что их можно использовать где-то еще. Допустим у нас модуль это UIViewController, Presenter - каждой из этих частей следует иметь возможность испльзоваться где-то еще. Например подлючить другую логику в UIViewController или же подключить Presenter к другому UIViewController 
- модульный ассемблер  
    Модуль должен собирать кто-то. Если вы уверены в своей архитектуре - сделайте протоколы и автоматизируйте процесс. Если нет, создавайте в ручную каждый модуль. Модульный ассемблер должен возвращать структуру в которой находятся все сущности для работы с модулем. Он позволит не задумываться с weak и unowned в Вашем модуле 


### примеры 
```swift 

protocol ModuleViewControllerEventOutput: AnyObject {
  // contains all events from ModuleViewController
}

protocol ModuleViewControllerPublicInterface: AnyObject {
  // contains all public api methods for outer usage
}

protocol ModuleViewControllerInterfaceContract: AnyObject {
  // contains all methods for business logic entities control
}

class ModuleViewController: UIViewController {
  // basic setup
  
  weak var eventOutput: ModuleViewControllerEventOutput?
  weak lazy var publicInterface: ModuleViewControllerPublicInterface = self
}

extension ModuleViewController: ModuleViewControllerInterfaceContract {
  // realization 
}

extension ModuleViewController: ModuleViewControllerPublicInterface {
  // realization 
}
```
**ModuleViewControllerEventOutput** отдает ивенты юая кому-угодно.  
**ModuleViewControllerPublicInterface** говорит какие методы доступны для взаимодействия с модулем.  
**ModuleViewControllerInterfaceContract** дает более низкоуровневый доступ к юаю для написания более гибкой логики. Должен использоваться сущностями с бизнес логикой  

Единственная зависимость тут это UIKit/SwiftUI, он по определению всегда идет слоем ниже. Поэтому все окей

Стоит заметить что в UIViewController, нет ничего, ни логики юай, ни запрос в сеть. Это все должно быть сделано в Presenter (как называется сущность, которая берет на себя всю логику по большей части это не важно, но в дальшейшем я буду ее называть именно так)

```swift 
protocol ModulePresenterNetworkingContract {
    // all methods to work with network
}

class ModulePresenter {
    init(networkingContract: ModulePresenterNetworkingContract, interfaceContract: ModuleViewControllerInterfaceContract) {
        // business logic 
    }
}

extension ModulePresenter: ModuleViewControllerEventOutput {
    // reaction on events 
}
```
Presenter опять таки тоже ни от кого не зависит. Будет его NetworkingContract реализовывать сущность Singleton или же просто сами с нуля напишем - его это не волнует. Дайте, а он уже все сделает что нужно.  

Не важно передаються ли данные через RxSwift, все что тут было описано можно переписать через него. Не важно делите вы еще сильнее Presenter, главное это описанные пункты выше
