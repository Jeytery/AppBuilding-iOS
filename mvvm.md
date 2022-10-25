# MVVM

Этот UI архитектурный паттерн используеться чаще всего в связке с RxSwift или Combine. В ином случае это все превращается в MVP. 
На самом деле если добавить реативщину в MVP, то она очень быстро станет MVVM. \
\
Добавляя реативищну к VIPER, мы получим сильно прокачанный MVVM с блэкджэком и интеркаторами. На самом деле такую солянку даже страшно представить, правда, если ViewModel начнет быть сильно массивной, то частичное или полное воплощение VIPER должно помочь распилить ее на более маленькие сущности \
\
Абстрактно вся концепция звучит так. View отдает юай ивенты, ViewModel получает юай ивенты, обрабатывает, реализуеют безнеслогику итд. Реакция на ивенты от ViewModel может быть разная, в зависимости от трактовки (об этом подробнее в примерах). ViewModel может спокойно отдавать ивенты, на который View нужно будет реагировать (что мне не очень нравится). Так же есть сценарий где ViewModel просто использует протокол, который реализует юай. Тогда вью просто должна его конфермить. Такой вариант мне нравиться больше, потому что теперь наша вью очень глупая, ей не надо реагирывать ни на что, просто реализовала все, что от нее требуется по протоколу. \
\
Посмотрим пример двух сценарией MVVM
```swift
protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
````

```вариант 1```
```swift 
class RootViewController: UIViewController {
  
    private let viewModel: RootViewModel
    private let bag = DispasedBag()

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init()
        bind()
    }
    
    private func bind() {
        let input = RootViewModel.Input(
            add: button.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
    
        output.joke
            .drive(onNext: {
                value in
                self.addString(value)
            },
            onCompleted: nil,
            onDisposed: nil
        )
        .disposed(by: bag)
        
        output.isLoading.subscribe {
            isLoading in
            if isLoading {
                self.startLoading()
            else {
                self.stopLoading()
            }
        }
        .disposed(by: bag)
    }
}
```
В даннов случае ViewModel для нас темный ящик (прямая цитата из доклада). Мы не знаем, что в ней. Мы просто подписываемся на ивет когда приходит joke - все. Так же мы должны удовлетворить Input ивенты структуры. Тут это ивент нажатия на кнопку, чтобы ViewModel уже как-то под капотом могла это обработать. \
\
Внимания стоит строчка 
```swift 
output.isLoading.subscribe {
    isLoading in
    if isLoading {
        self.startLoading()
    
    else {
        self.stopLoading()
    }
}
.disposed(by: bag)
```
Мне не очень нравиться такой стиль MVVM. Нам буквально нужно на что-то реагировать, думать о каких-то стейтах, дополнять эту логику в других вью, если мы захотим использовать ViewModel еще где-то. Я не хочу лишний раз задумываться как мне нужно взаимодействовать с определнной ViewModel \
Мой субъективно более предпочтительный вариант \
``` вариант 2```

```swift 

// протокол который нужен ViewModel для корректной работы
protocol RootViewModelUIInput {
    func startLoading()
    func stopLoading()
}

class RootViewController: UIViewController {
   
   private let viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        ...
        bind()
    }   
    
    private func bind() {
    }
}

extension RootViewController: RootViewModelUIInput {
    ... make all required funcs 
}

```
Assembly module
``` swift 
    extension RootViewController {
        static func module() -> RootViewController {
            let viewModel = RootViewModel()
            let vc = RootViewController(viewModel: viewModel)
            viewModel.input = vc
            return vc
        }
    }
```
Теперь байнд такой 
```swift 
private func bind() {
    let input = RootViewModel.Input(
        add: button.rx.tap.asDriver()
    )
    let _ = viewModel.transform(input: input)
}
        
```
Ouput как понятия для нас умирает. Я оставил его только потому что, ну может оттуда может быть что-то важное приходить. Но по существу мы теперь делаем две вещи и они для нас всегда одинаковые - отдаем ивенты и реализовываем юай функции. А когда их использовать, по каким принципам и логике - все это решает ViewModel. А View остаеться очень глупой, только отдает ивенты и только реализует юай функции \
\
[Ссылка](#mvvm) на полный проект

