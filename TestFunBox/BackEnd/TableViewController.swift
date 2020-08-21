//
//  TableViewController.swift
//  TestFunBox
//
//  Created by Stanislav on 13.08.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        // Если сегвей имеет идентификатор, то выполняем код, если нет, то просто сворачиваем окно
        guard unwindSegue.identifier == "saveSegue" else { return }
        let sourceViewController = unwindSegue.source as! EditingTableViewController // Получаем доступ к нужному контроллеру
        let item = sourceViewController.item // Получаем доступ к нужному свойству
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // Если индекс текущей ячейки есть, то идем дальше
                let product = Items.shared.items[selectedIndexPath.row]
                // Операция сохранения изменений имеет задержку 5 секудн и выполняется на отдельном потоке
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    product.name = item.name
                    product.price = item.price
                    product.count = item.count
                    self.tableView.reloadData()
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                })
            } else { // Если индекса нет, то сохраняем товар как новый объект CoreData
                let indexPath = IndexPath(row: Items.shared.items.count, section: 0)
                let product = ItemCoreData(context: context)
                product.name = item.name
                product.price = item.price
                product.count = item.count
                
                Items.shared.items.append(product)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData() // При каждом открытии экрана обновляем таблицу, для отображения актуальных данных
    }
    
    
    // При нажатии на ячейку, если совпадает сегвей, передаем данные на экран редактирования
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editSegue" else { return }
        let index = tableView.indexPathForSelectedRow! // Индекс текущей ячейки
        let item = Items.shared.items[index.row] // Получаем объект по нужному индексу
        let navVC = segue.destination as! UINavigationController
        let editVC = navVC.topViewController as! EditingTableViewController // Получаем доступ к нужному контроллеру
        
        let name = item.name
        let price = item.price
        let count = item.count
        
        // Присваиваем свойству контроллера новые значения
        editVC.item = (name!, price!, count!)
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Items.shared.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "backEndCell", for: indexPath) as! BackEndTableViewCell
        
        cell.nameLabel.text = Items.shared.items[indexPath.row].name
        cell.countLabel.text = Items.shared.items[indexPath.row].count! + "шт"
        
        return cell
    }
    
    // Метод удаления ячейки и объекта
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let product = Items.shared.items[indexPath.row]
        context.delete(product)
        
        do {
            try context.save()
            Items.shared.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
