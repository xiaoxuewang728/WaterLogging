//
//  TrackWaterViewController.swift
//  WaterLogging
//
//

import UIKit

protocol TrackWaterView: class {
    func update(quantity: Double)
    func update(goal: Double?)
}

class TrackWaterViewController: UIViewController, TrackWaterView {
    
    private var presenter: TrackWaterViewPresenter!
    private let dateLabel = UILabel()
    private let quantityUnitView = TrackWaterUnitView(header: "Consumed", content: "0 oz")
    private let goalUnitView = TrackWaterUnitView(header: "Your Goal", content: "n/a")
    private let addWaterButton = UIButton()
    private let instructionLabel = UILabel()
    private let updateGoalButton = UIButton()
    private let warningLabel = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TrackWaterPresenter(view: self)
        presenter?.updateGoal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updateDataIfNeeded()
        dateLabel.text = Date().toString()
    }

    // Set Up
    
    private func setUp() {
        dateLabel.text = Date().toString()
        addWaterButton.setTitle("Add 8 oz Water", for: .normal)
        updateGoalButton.setTitle("Update Daily Goal", for: .normal)
        addWaterButton.addTarget(self, action: #selector(addWaterButtonPressed), for: .touchUpInside)
        instructionLabel.text = "Please allow this app to read weight from health in order to calculate daily goal based on weight"
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        updateGoalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
        warningLabel.numberOfLines = 0
        warningLabel.textAlignment = .center
        
        view.backgroundColor = .systemBackground
        addWaterButton.backgroundColor = .black
        updateGoalButton.backgroundColor = .black
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let container = UIView()

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(dateLabel)

        let unitViewContainer = UIView()
        unitViewContainer.translatesAutoresizingMaskIntoConstraints = false
        quantityUnitView.translatesAutoresizingMaskIntoConstraints = false
        goalUnitView.translatesAutoresizingMaskIntoConstraints = false
        unitViewContainer.addSubview(quantityUnitView)
        unitViewContainer.addSubview(goalUnitView)
        container.addSubview(unitViewContainer)

        // unit views constraints
        let quantityUnitViewConstraints = [quantityUnitView.topAnchor.constraint(equalTo: unitViewContainer.topAnchor),
                                           quantityUnitView.leadingAnchor.constraint(equalTo: unitViewContainer.leadingAnchor),
                                           quantityUnitView.bottomAnchor.constraint(equalTo: unitViewContainer.bottomAnchor)]

        NSLayoutConstraint.activate(quantityUnitViewConstraints)

        let goalUnitViewConstraints = [goalUnitView.topAnchor.constraint(equalTo: unitViewContainer.topAnchor),
                                       goalUnitView.leadingAnchor.constraint(equalTo: quantityUnitView.trailingAnchor, constant: 50),
                                       goalUnitView.trailingAnchor.constraint(equalTo: unitViewContainer.trailingAnchor),
                                       goalUnitView.bottomAnchor.constraint(equalTo: unitViewContainer.bottomAnchor)]

        NSLayoutConstraint.activate(goalUnitViewConstraints)

        addWaterButton.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        updateGoalButton.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addWaterButton)
        container.addSubview(instructionLabel)
        container.addSubview(updateGoalButton)
        container.addSubview(warningLabel)
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)

        // dateLabel constraints
        let dateLabelConstraints = [dateLabel.topAnchor.constraint(equalTo: container.topAnchor),
                                    dateLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)]

        NSLayoutConstraint.activate(dateLabelConstraints)

        // unitViewContainer constraints
        let unitViewContainerConstraints = [unitViewContainer.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
                                            unitViewContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                            unitViewContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor)]

        NSLayoutConstraint.activate(unitViewContainerConstraints)

        // Buttons constraints
        let addWaterButtonConstraints = [addWaterButton.topAnchor.constraint(equalTo: unitViewContainer.bottomAnchor, constant: 50),
                                         addWaterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                         addWaterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),]

        NSLayoutConstraint.activate(addWaterButtonConstraints)

        let instructionLabelConstraints = [instructionLabel.topAnchor.constraint(equalTo: addWaterButton.bottomAnchor, constant: 10),
                                           instructionLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                           instructionLabel.widthAnchor.constraint(equalToConstant: 300)]

        NSLayoutConstraint.activate(instructionLabelConstraints)

        let updateGoalButtonConstraints = [updateGoalButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
                                           updateGoalButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                           updateGoalButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)]

        NSLayoutConstraint.activate(updateGoalButtonConstraints)

        let warningLabelConstraints = [warningLabel.topAnchor.constraint(equalTo: updateGoalButton.bottomAnchor, constant: 10),
                                       warningLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                       warningLabel.widthAnchor.constraint(equalToConstant: 300),
                                       warningLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)]

        NSLayoutConstraint.activate(warningLabelConstraints)

        // ContainerView constraints
        
        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 100),
                                    container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    container.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor)]
        
        NSLayoutConstraint.activate(containerConstraints)
        
    }
    
    // Actions
    
    @objc private func addWaterButtonPressed() {
        presenter?.intakeWater(quantity: 8.0)
        print("Add water button pressed")
    }
    
    @objc private func goalButtonPressed() {
        presenter?.updateGoal()
        warningLabel.text = ""
        print("Goal button pressed")
    }

    func update(quantity: Double) {
        quantityUnitView.updateContent(text: "\(quantity) oz")
    }

    func update(goal: Double?) {
        if let goal = goal {
            goalUnitView.updateContent(text: "\(String(format: "%.1f", goal)) oz")
            warningLabel.textColor = UIColor.black
            warningLabel.text = "Goal is already set based on your weight"
        } else {
            goalUnitView.updateContent(text: "n/a")
            warningLabel.textColor = UIColor.orange
            warningLabel.text = "Please make sure you \n(1) set weight in Health app \n(2) grant aceess to Health data \n(3) click on button above to try this flow again"
        }
    }
}
