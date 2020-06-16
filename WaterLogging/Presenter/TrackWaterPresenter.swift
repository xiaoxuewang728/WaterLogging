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
}

class TrackWaterPresenter: TrackWaterViewPresenter {
    private unowned var view: TrackWaterView
    required init(view: TrackWaterView) {
        self.view = view
    }
}
