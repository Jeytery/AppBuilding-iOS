Модуль Вашего приложения должен быть гибок. Используете ли вы VIPER или MVVМ это не важно.
Следующий цели, которые должны достигаться модулем

- полная независимость от проектны слоев  
    Модуль должен иметь интерфесы для взаимодействия с собой. Это нужно чтобы использовать его где-угодно
    
- разбираемость на кусочки  
    Часть модуля должны быть сделаны так, что их можно использовать где-то еще. Допустим у нас модуль это UIViewController, Presenter - каждой из этих частей следует иметь возможность испльзоваться где-то еще. Например подлючить другую логику в UIViewController или же подключить Presenter к другому UIViewController 

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

Стотит заметить что в UIViewController, нет ничего, ни логики юай, ни запрос в сеть. Это все должно быть сделано в Presenter (как называется сущность, которая берет на себя всю логику по большей части это не важно, но в дальшейшем я буду ее называть именно так)

