/*:
 ## Задание 4: Создание единой подписки
 С помощью Combine создайте для заданых subject единую подписку со значением типа `Int` в блоке `sink`
*/

import Combine

let subject1 = PassthroughSubject<Int, Never>()
let subject2 = PassthroughSubject<String, Never>()

let subscription1 = subject1
    .sink { num in
        print("subscription1: \(num)")
    }

let subscription2 = subject2
    .sink { str in
        print("subscription2: \(str)")
    }

Publishers.CombineLatest(subject1, subject2)
    .map { int, str in
        int + (Int(str) ?? 0)
    }
    .sink {
        print("combinedSubscription: \($0)")
    }


[(5, "1"), (10, "2"), (15, "abc"), (20, "4"), (25, "5g"), (30, "6"), (35, "7"), (40, "qwerty"), (45, "9")]
    .forEach { int, str in
        subject1.send(int)
        subject2.send(str)
    }
