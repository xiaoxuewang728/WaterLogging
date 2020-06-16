//
//  TrackWaterPresenter.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol TrackWaterViewPresenter {
    init(view: TrackWaterView)
    func intakeWater(quantity: Double)
    func updateDataIfNeeded()
    func updateGoal()
}

class TrackWaterPresenter: TrackWaterViewPresenter {

    private unowned var view: TrackWaterView

    required init(view: TrackWaterView) {
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

    @objc private func updateQuantity(notification: Notification) {
        let quantityOfToday = notification.object as! Double
        view.update(quantity: quantityOfToday)
    }

    @objc private func updateGoal(notification: Notification) {
        if notification.object == nil {
            view.update(goal: nil)
        } else {
            let weight = notification.object as! Double
            view.update(goal: weight * Constants.waterGoalToWeightRatio)
        }
    }

    func intakeWater(quantity: Double) {
        CoreDataManager.shared.addWaterLog(quantity: quantity)
    }

    func updateDataIfNeeded() {
        CoreDataManager.shared.fetchWaterLog()
    }

    func updateGoal() {
        HealthKitManager.shared.requestPermissions()
    }
}
