/*:
 ## Задание 3: Собирание данных
 Используйте Combine для того, чтобы собирать значения, которые приходят от publisher в коллекцию некоторой длины

 1. Создайте subject, которому будете отправлять какое-то количество значений
 2. Используйте операторы для того, чтобы собрать значения с publisher в нужном количестве и объединить их
 3. Отправляйте подписчику коллекцию значений с заданым количеством элементов
 */

import Combine


let subject = PassthroughSubject<Int, Never>()
let collectionSize = 3

subject
    .collect(collectionSize)
    .sink { collection in
        print(collection)
    }

(0...10).forEach {
    subject.send($0)
}
