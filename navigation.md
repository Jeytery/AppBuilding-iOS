# Navigation
Navigation is small layer inside your project to create Coordinators in more organized way 

Each Coordinator should have completion handler so:
```swift 
protocol StatelessCompletionable {
    var completion: (() -> Void)? { get set }
}
```

Also optional start method but you can do it always in init()

```swift
protocol Coordinatable: StatelessCompletionable, AnyObject {
    func start()
    func add(coordinatable: Coordinatable)
    func remove(coordinatable: Coordinatable)

    var childCoordinators: [Coordinatable] { get set }
}
```
add() and remove() are used to add new coordinators and put it in childCoordinators. Here some logic in extension 
```swift
extension Coordinatable {
    func add(coordinatable: Coordinatable) {
        guard !childCoordinators.contains(where: {
            $0 === coordinatable
        }) else {
            return
        }
        childCoordinators.append(coordinatable)
    }
    
    func remove(coordinatable: Coordinatable) {
        if childCoordinators.isEmpty { return }
        if !coordinatable.childCoordinators.isEmpty {
            coordinatable.childCoordinators
                .filter {
                    $0 !== coordinatable
                }
                .forEach {
                    coordinatable.remove(coordinatable: $0)
                }
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinatable {
            childCoordinators.remove(at: index)
            break
        }
    }
}
```

[Library here](https://github.com/swiftonica/NavigationLayer)
