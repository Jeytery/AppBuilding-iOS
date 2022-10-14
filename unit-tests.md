# Unit tests

### что это? 
Тестирование отдельного модуля программы. Фрейворк предоставляет для этого различные фукнции. Тестирование имеет некоторые подходы, которые позволяют отестить с определенной гибкостью

### зачем нужны? 
- проверка, что код работает во всех ожидаемых нами случаях 
- при вводе новых неправильных изменений разрабом - тесту упадут и не позволят плохим изменениям попасть в проект 
- тесты - часть доки. По ним проще разробраться что просиходит в сущностях 

### виды тестовых объектов 
Эти объекты прокидываються в классы, чтобы у последнего в свою очередь не было зависимостей от кого-либо
- mock (заглушка, это любой пустой объект)
```swift 
class MockNetworkManager: NetworkManagerTarget {
    func downlad(... args) {
        // empty 
    }

    func perform<Model: Encodable>(... args) {
        // empty
    }

    func getSomeArray() -> [Int] {
        return []
    }

    func getSomeValue() -> Int? {
        return nil
    }
}
```
- stub (имитируют какое-то поведение)
```swift 
class StubNetworkManager: NetworkManagerTarget {
    func downlad(... args) {
        // some standard realization like in 'perform()' 
    }

    func perform<Model: Encodable>(request: NetworkReqeust, completion: (Result<NetworkResponse<Model>, Error>) -> Void where Model: Decodable) {
        // always return success status with data and status code 200
        let model = try! JSONEncoder().decode(Model.self, from: Data())
        comletion(.success(init(httpCode: 200, data: model)))
    }

    func getSomeArray() -> [Int] {
        return [1, 2 ,3]
    }

    func getSomeValue() -> Int? {
        return 1
    
```
- spy (отслуживание поведения во время теста) 
``` swift 
class SpyNetworkManager: NetworkManagerTarget {

    // closure with clousre as argument inside 
    var downloadSpy: ((NetworkReqeust, (Result<URL, Error) -> Void) -> Void)? 

    func downlad(request: NetworkReqeust, _ completion: @escaping (Result<URL, Error>) -> Void) {
        downloadSpy?(request, completion)
    }

    func perform<Model: Encodable>(request: NetworkReqeust, completion: (Result<NetworkResponse<Model>, Error>) -> Void where Model: Decodable) {
        // as in 'download()'
    }
}
```
### links

https://www.youtube.com/watch?v=RWrDahv8m0I&t=404s \
https://habr.com/ru/post/654591/ \
https://github.com/oleh-zayats/awesome-unit-testing-swift \
https://www.vadimbulavin.com/real-world-unit-testing-in-swift/ \
https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial

