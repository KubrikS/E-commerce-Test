//
//  EditingTableViewController.swift
//  TestFunBox
//
//  Created by Stanislav on 13.08.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit
import CoreData

class EditingTableViewController: UITableViewController {
    
    var item: (name: String, price: String, count: String) = ("", "", "")
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var countTextField: UITextField!
    
    // Отслеживание изменений в текстовом поле
    @IBAction func changeTextField(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateSaveButtonState()
        
        // отключение автокоррекции из-за ошибки, возникающей при наборе текса
        nameTextField.autocorrectionType = .no
        priceTextField.autocorrectionType = .no
        countTextField.autocorrectionType = .no
    }
    
    // Метод активации активного состояния кнопки "Сохранить"
    private func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let count = countTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !price.isEmpty && !count.isEmpty
    }
    
    // Метод заполнения текстфилдов значениями, полученными при нажатии на ячейку
    private func updateUI() {
        nameTextField.text = item.name
        priceTextField.text = item.price
        countTextField.text = item.count
    }
    
    // При закрытии окна редактирования сохраняем в переменную значения текстфилда
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        self.item = (nameTextField.text!,
                     priceTextField.text!,
                     countTextField.text!)
    }
}
