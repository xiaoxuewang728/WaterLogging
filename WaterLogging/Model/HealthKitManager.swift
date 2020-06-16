//
//  HealthKitManager.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {

    static let shared = HealthKitManager()

    private let healthStore = HKHealthStore()
    private var bodyMassObserverQuery: HKObserverQuery?

    var weight: Double? = nil {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BodyMassDataAvailableOrUpdated"),
                                            object: weight,
                                            userInfo: nil)
        }
    }

    public func requestPermissions() {
        let typesToRead: Set = [HKQuantityType.quantityType(forIdentifier: .bodyMass)!]
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] (success, error) in
            if success {
                print("Authorization complete")
                self?.startObserving()
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func startObserving() {
        guard let bodyMassType = HKSampleType.quantityType(forIdentifier: .bodyMass) else { return }
        bodyMassObserverQuery = HKObserverQuery(
            sampleType: bodyMassType,
            predicate: nil) { [weak self] (query, completion, error) in
                self?.bodyMassObserverQueryTriggered()
                completion()
        }

        healthStore.execute(bodyMassObserverQuery!)
    }

    func bodyMassObserverQueryTriggered() {
        guard let bodyMassType = HKSampleType.quantityType(forIdentifier: .bodyMass) else { return }
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        let limit = 1
        let bodyMassSampleQuery = HKSampleQuery(
                sampleType: bodyMassType,
                predicate: mostRecentPredicate,
                limit: limit,
                sortDescriptors: [sortDescriptor],
                resultsHandler: { [weak self] (query, samples, error) in
                    DispatchQueue.main.async(execute: {
                        guard let samples = samples as? Array<HKQuantitySample> else { return }
                        if samples.count > 0 {
                            self?.weight = samples[0].quantity.doubleValue(for: HKUnit.init(from: .pound))
                        } else {
                            self?.weight = nil
                        }
                    })
            })
        healthStore.execute(bodyMassSampleQuery)
    }
}
