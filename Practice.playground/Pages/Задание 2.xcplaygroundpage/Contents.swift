/*:
 ## Задание 2: Комбинированные потоки данных
 Используйте Combine для комбинирования данных из двух источников:

 1. Создайте два издателя (publishers) с числовыми значениями.
 2. Сложите значения из обоих издателей.
 3. Умножьте полученную сумму на 2.
 4. Выведите результат в консоль.
 */

import Combine

let firstNumer = Just(5)
let secondNumer = Just(10)

Publishers.CombineLatest(firstNumer, secondNumer)
    .map { firstNumber, secondNumer in
        (firstNumber + secondNumer) * 2
    }
    .sink { print("Результат: \($0)")}

