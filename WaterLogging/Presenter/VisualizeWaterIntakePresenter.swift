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
}

class VisualizeWaterIntakePresenter: VisualizeWaterIntakeViewPresenter {
    private unowned var view: VisualizeWaterIntakeView
    required init(view: VisualizeWaterIntakeView) {
        self.view = view
    }
}
