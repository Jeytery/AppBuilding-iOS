# Patterns 

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
два Can't handle - callPhone и manager не смошли. Done - expert смог ответить на вопрос, дальше сам ответ

### sources
https://github.com/artkirillov/DesignPatterns
