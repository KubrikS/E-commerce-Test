//
//  AppDelegate.swift
//  TestFunBox
//
//  Created by Stanislav on 13.08.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit
import CoreData
import CSV

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        fetchCoreDataObject() // Делаем запрос в CoreData для получения массива объектов
        
        let path = Bundle.main.path(forResource: "data", ofType: "csv")
        let stream = InputStream(fileAtPath: path!)!
        let csv = try! CSVReader(stream: stream)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            if Items.shared.items.count == 0 {
                while let row = csv.next() {
                    let product = ItemCoreData(context: context)
                    product.name = row[0]
                    product.price = row[1]
                    product.count = row[2]
                    
                    Items.shared.items.append(product)
                }
            } 
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ItemCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func fetchCoreDataObject() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ItemCoreData> = ItemCoreData.fetchRequest()
        
        do {
            Items.shared.items = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

