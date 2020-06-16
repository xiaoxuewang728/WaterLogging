//
//  VisualizeWaterIntakeViewController.swift
//  WaterLogging
//
//

import UIKit

protocol VisualizeWaterIntakeView: class {
    func update(quantity: Double)
    func update(goal: Double?)
    func update(percentage: Double)
}

class VisualizeWaterIntakeViewController: UIViewController, VisualizeWaterIntakeView {

    private var presenter: VisualizeWaterIntakeViewPresenter!
    private let percentageUnitView = TrackWaterUnitView(header: "Progress", content: "0%")
    private let progressView = ProgressView()
    private let trackingLabel = UILabel()
    
    private var quantity: Double = 0.0
    private var goal: Double? = nil
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = VisualizeWaterIntakePresenter(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updateDataIfNeeded()
    }

    // Set Up

    private func setUp() {
        trackingLabel.text = "0 oz of n/a oz goal consumed today"
        trackingLabel.textColor = .label
        trackingLabel.textAlignment = .center
        view.backgroundColor = .systemBackground
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        percentageUnitView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        trackingLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(percentageUnitView)
        container.addSubview(progressView)
        container.addSubview(trackingLabel)

        // percentageUnitView constraints

        let percentageUnitViewConstraints = [percentageUnitView.topAnchor.constraint(equalTo: container.topAnchor),
                                             percentageUnitView.centerXAnchor.constraint(equalTo: container.centerXAnchor)]

        NSLayoutConstraint.activate(percentageUnitViewConstraints)

        // progressView constraints

        let progressViewConstraints = [progressView.topAnchor.constraint(equalTo: percentageUnitView.bottomAnchor, constant: 20),
                                       progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                       progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                       progressView.widthAnchor.constraint(equalToConstant: 300.0),
                                       progressView.heightAnchor.constraint(equalToConstant: 300.0)]

        NSLayoutConstraint.activate(progressViewConstraints)

        // trackingLabel constraints

        let trackingLabelConstraints = [trackingLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
                                        trackingLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                        trackingLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                        trackingLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)]

        NSLayoutConstraint.activate(trackingLabelConstraints)

        // container constraints

        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)]

        NSLayoutConstraint.activate(containerConstraints)
    }

    func update(quantity: Double) {
        self.quantity = quantity
        if let goal = goal {
            trackingLabel.text = "\(quantity) oz of \(String(format: "%.1f", goal)) oz goal consumed today"
        } else {
            trackingLabel.text = "\(quantity) oz of n/a oz goal consumed today"
        }
    }

    func update(goal: Double?) {
        self.goal = goal
        if let goal = goal {
            trackingLabel.text = "\(quantity) oz of \(String(format: "%.1f", goal)) oz goal consumed today"
        } else {
            trackingLabel.text = "\(quantity) oz of n/a oz goal consumed today"
        }
    }

    func update(percentage: Double) {
        progressView.percentage = percentage
        percentageUnitView.updateContent(text: percentage.percentageString)
    }
}

extension Double {
    var percentageString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? "0%"
    }
}
