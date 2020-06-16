//
//  VisualizeWaterIntakePresenter.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol VisualizeWaterIntakeViewPresenter {
    init(view: VisualizeWaterIntakeView)
    func updateDataIfNeeded()
}

class VisualizeWaterIntakePresenter: VisualizeWaterIntakeViewPresenter {
    private unowned var view: VisualizeWaterIntakeView
    required init(view: VisualizeWaterIntakeView) {
        self.view = view
        listenToNotifications()
    }

    private func listenToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateQuantity(notification:)),
                                               name: NSNotification.Name(rawValue: "QuantityUpdated"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGoal(notification:)),
                                               name: NSNotification.Name(rawValue: "BodyMassDataAvailableOrUpdated"),
                                               object: nil)
    }

    @objc private func updateGoal(notification: Notification) {
        if notification.object == nil {
            view.update(goal: nil)
            view.update(percentage: 0.0)
        } else {
            let weight = notification.object as! Double
            let goal = weight * Constants.waterGoalToWeightRatio
            view.update(goal: goal)
            view.update(percentage: CoreDataManager.shared.quantityOfToday / goal)
        }
    }

    @objc private func updateQuantity(notification: Notification) {
        let quantityOfToday = notification.object as! Double
        view.update(quantity: quantityOfToday)
        if let weight = HealthKitManager.shared.weight {
            let goal = weight * Constants.waterGoalToWeightRatio
            view.update(percentage: quantityOfToday / goal)
        } else {
            view.update(percentage: 0.0)
        }
    }

    func updateDataIfNeeded() {
        CoreDataManager.shared.fetchWaterLog()
    }
}
