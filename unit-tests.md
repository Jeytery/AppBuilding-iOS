# Unit tests

### что это? 
Тестирование отдельного модуля программы. Фрейворк предоставляет для этого различные фукнции. Тестирование имеет некоторые подходы, которые позволяют отестить с определенной гибкостью

### зачем нужны? 
- проверка, что код работает во всех ожидаемых нами случаях 
- при вводе новых неправильных изменений разрабом - тесту упадут и не позволят плохим изменениям попасть в проект 
- тесты - часть доки. По ним проще разробраться что просиходит в сущностях 

### виды тестовых объектов 
Эти объекты прокидываються в классы, чтобы у последнего в свою очередь не было зависимостей от кого-либо
- spy (отслуживание поведения во время теста) 
- stub (имитируют какое-то поведение)
- mock (заглушка, это любой пустой объект)
```swift 
class MockNetworkService: NetworkManagerTarget {
    func downlad(... args) {
        // empty 
    }

    func perform<Model: Encodable>(... args) {
        // empty
    }
}
````


### links

https://www.youtube.com/watch?v=RWrDahv8m0I&t=404s \
https://habr.com/ru/post/654591/ \
https://github.com/oleh-zayats/awesome-unit-testing-swift \
https://www.vadimbulavin.com/real-world-unit-testing-in-swift/ \
https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial

