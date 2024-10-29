import UIKit
import Combine

class ViewController: UIViewController {

    //MARK: Views
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var multiplyButton: UIButton!
    
    //MARK: Properties
    private let inputTextSubject = CurrentValueSubject<String?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }

    //MARK: - Actions
    @IBAction func multiplyButtonTapped(_ sender: UIButton) {
        guard let text = inputTextField.text, let number = Int(text) else { return }
        
        asyncMultiplyByTwo(number: number)
            .receive(on: DispatchQueue.main)
            .map{ String($0) }
            .assign(to: \.text, on: resultLabel)
            .store(in: &cancellables)
    }
}

//MARK: - Private Methods
private extension ViewController {
    
    //Добавляет action для отслеживания ввода текста
    func setupTextField() {
        inputTextField.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                let text = inputTextField.text
                inputTextSubject.send(text)
            },
            for: .editingChanged
        )
        
        inputTextSubject
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { Int($0 ?? "" ) != nil }
            .sink(receiveValue: { [weak self] isValid in
                guard let self else { return }
                updateUI(isValid: isValid)
            })
            .store(in: &cancellables)
    }
    
    //Асинхронно выполняет умножение переданного числа на 2 со случайной задержкой до 3 секунд
    func asyncMultiplyByTwo(number: Int) -> AnyPublisher<Int, Never> {
        Deferred {
            Future { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + .random(in: 1...3)) {
                    promise(.success(number * 2))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateUI(isValid: Bool) {
        multiplyButton.isEnabled = isValid
        inputTextField.textColor = isValid ? resultLabel.textColor : UIColor.systemRed
    }
}
