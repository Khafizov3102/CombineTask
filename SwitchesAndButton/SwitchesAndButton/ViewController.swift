import UIKit
import Combine

final class ViewController: UIViewController {
    
    //MARK: Views
    private var switch1 = UISwitch()
    private var switch2 = UISwitch()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [switch1, switch2, button])
        stack.spacing = 10
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @Published private var switch1IsOn: Bool = false
    @Published private var switch2IsOn: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        
        switch1.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        switch2.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        isButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: button)
            .store(in: &cancellables)
    }
    
    private var isButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($switch1IsOn, $switch2IsOn)
            .map { switch1, switch2 in
                return switch1 && switch2
            }.eraseToAnyPublisher()
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        if sender == switch1 {
            switch1IsOn = sender.isOn
        } else if sender == switch2 {
            switch2IsOn = sender.isOn
        }
    }
}

//MARK: - UI Setup
private extension ViewController {
    func setupViews() {
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 60),
            vStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
