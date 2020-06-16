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
    }

    @objc private func updateQuantity(notification: Notification) {
        let quantityOfToday = notification.object as! Double
        view.update(quantity: quantityOfToday)
    }

    func intakeWater(quantity: Double) {
        CoreDataManager.shared.addWaterLog(quantity: quantity)
    }

    func updateDataIfNeeded() {
        CoreDataManager.shared.fetchWaterLog()
    }
}
