//
//  CoreDataManager.swift
//  WaterLogging
//
//  Created by WangXiaoxue on 6/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    var quantityOfToday: Double = 0.0 {
        didSet {
            // TODO: notify presenter
        }
    }

    private func setContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }

    func addWaterLog(quantity: Double) {
        let context = setContext()
        let newWaterLog = WaterLog(context: context)
        newWaterLog.date = Date()
        newWaterLog.quantity = quantity
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        fetchWaterLog()
    }

    func fetchWaterLog() {
        let waterLogs: [WaterLog]
        let context = setContext()
        let request = NSFetchRequest<WaterLog>(entityName: "WaterLog")
        let calendar = Calendar.current
        let today = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let now = Date()
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", today! as CVarArg, now as CVarArg)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            waterLogs = try context.fetch(request)
            var amount: Double = 0.0
            for log in waterLogs {
                amount += log.quantity
            }
            quantityOfToday = amount
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
