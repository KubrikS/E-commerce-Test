//
//  CollectionViewController.swift
//  TestFunBox
//
//  Created by Stanislav on 13.08.2020.
//  Copyright © 2020 St. Kubrik. All rights reserved.
//

import UIKit
import CoreData


class CollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var notItemLabel: UILabel!
    
    // Кнопка покупки товара
    @IBAction func buyButton(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let index = self.collectionView.indexPathsForVisibleItems.map { $0.item } // Получаем массив с индексом текущей ячейки
            let indexPath = index[0] // Достаем индекс из массива
            let item = Items.shared.items.filter{ $0.count != "0" } // Фильтруем объект по количеству товара
            let product = item[indexPath] // Получаем текущий товар
            
            // Проверка. Если количество не равно 0, то при нажатии на кнопку отнимаем 1, в противном случае ничего не происходит
            if product.count != "0" {
                guard let count = Int(product.count!) else { return }
                product.count = "\(count - 1)"
                hiddenNitItemLabel()
                self.collectionView.reloadData()
            }
            try context.save() // сохраняем контекст
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hiddenNitItemLabel() // Показываем надпись "В магазине пусто" после проверки
        collectionView.reloadData() // Перезагрузка коллекции при открытии экрана
    }
    
    private func hiddenNitItemLabel() {
        if Items.shared.items.filter({ $0.count != "0" }).count == 0 { // Сортируем массив по количеству товара
            notItemLabel.isHidden = false
        } else {
            notItemLabel.isHidden = true
        }
    }
}


extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Items.shared.items.filter{ $0.count != "0" }.count
    }
    
    // Отображение данных в ячейке
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        
        let items = Items.shared.items.filter{ $0.count != "0" }

        cell.nameLabel.text = items[indexPath.item].name
        cell.priceLabel.text = items[indexPath.item].price! + "₽"
        cell.countLabel.text = items[indexPath.item].count! + "шт"
        
        return cell
    }
    
    
    
    // Настройка размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}
