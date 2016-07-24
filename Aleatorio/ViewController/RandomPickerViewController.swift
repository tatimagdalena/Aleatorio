//
//  RandomPickerViewController.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/20/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import UIKit

class RandomPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
//------------------------------
//MARK: Storyboard connections
//------------------------------
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var hideButton: UIButton!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var randomizeButton: UIButton!
    
    
//------------------------------
//MARK: Properties
//------------------------------
    let fontName: String = "Kannada Sangam MN"
    let fontNameBold: String = "KannadaSangamMN-Bold"
    let snorkelBlueColor: UIColor = UIColor(red: 11/255.0, green: 80/255.0, blue: 130/255.0, alpha: 1.0)
    let defaultRadius: CGFloat = 8.0
    var allItems: [ItemModel]!
    var notHiddenItems: [ItemModel]!
    
    var newItemTextField: UITextField?
    var isEditingList: Bool = false
    
    
//------------------------------
//MARK: Lifecycle
//------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        
        self.pickerView.selectRow(self.allItems.count/2, inComponent: 0, animated: false)
        
        self.endEdition(self.editButton)
//        self.addButton.hidden = true
//        self.deleteButton.hidden = true
//        self.hideButton.hidden = true
//        self.okButton.hidden = true
//        self.editButton.hidden = false
//        self.randomizeButton.enabled = true
        
        //let selectedRow = self.pickerView.selectedRowInComponent(0)
        //let selectedItemView = self.pickerView.viewForRow(selectedRow, forComponent: 0) as! PickerItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItems() {
        
        //["Frango à Parmegiana", "BK", "Zaitune", "Dioguinho", "Costelo", "Beco", "Conexão", "Toledo", "Galeto Castelo"]
        
        let item1 = ItemModel(name: "Frango à Parmegiana", isHidden: false)
        let item2 = ItemModel(name: "BK", isHidden: false)
        let item3 = ItemModel(name: "Zaitune", isHidden: false)
        let item4 = ItemModel(name: "Dioguinho", isHidden: false)
        let item5 = ItemModel(name: "Costelo", isHidden: false)
        let item6 = ItemModel(name: "Beco", isHidden: false)
        let item7 = ItemModel(name: "Conexão", isHidden: false)
        let item8 = ItemModel(name: "Toledo", isHidden: false)
        let item9 = ItemModel(name: "Galeto Castelo", isHidden: false)
        
        self.allItems = [item1, item2, item3, item4, item5, item6, item7, item8, item9]
        
    }
    
//------------------------------
//MARK: Buttons actions
//------------------------------
    
    @IBAction func randomizeSelection(sender: UIButton) {
        
        let itemsAmount = UInt32(self.allItems.count)
        let random = Int(arc4random_uniform(itemsAmount))
        
        self.resultLabel.text = allItems[random].name
        self.pickerView.selectRow(random, inComponent: 0, animated: true)
    }
    
    @IBAction func allowEdition(sender: AnyObject) {
        
        self.addButton.hidden = false
        self.deleteButton.hidden = false
        self.hideButton.hidden = false
        self.okButton.hidden = false
        self.editButton.hidden = true
        self.randomizeButton.enabled = false
        self.resultLabel.enabled = false
    }
    
    @IBAction func showAddItemAlert(sender: UIButton) {
        
        let alert = SimpleAlert.Controller(title: "Novo Item:", message: "", style: .Alert)
        
        alert.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = UIColor.whiteColor()
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            textField.placeholder = "Digite o novo restaurante"
            textField.font = UIFont(name: self.fontName, size: 14)
            self.newItemTextField = textField
        }
        
        alert.configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.textColor = self?.snorkelBlueColor
                view.titleLabel.font = UIFont(name: self!.fontNameBold, size: 20)
                //view.messageLabel.textColor = UIColor.lightGrayColor()
                //view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
                view.backgroundColor = UIColor.whiteColor()
                view.textBackgroundView.layer.cornerRadius = self!.defaultRadius
                view.textBackgroundView.clipsToBounds = true
            }
        }
        
        alert.configContainerCornerRadius = {
            return self.defaultRadius * 2
        }
        
        let cancelAction = SimpleAlert.Action(title: "Cancelar", style: .Cancel)
        let addAction = SimpleAlert.Action(title: "Adicionar", style: .OK)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        //cancelAction.button.frame.size.height = 144
        cancelAction.button.titleLabel?.font = UIFont(name: self.fontNameBold, size: 14)
        cancelAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelAction.button.backgroundColor = self.snorkelBlueColor
        
        addAction.button.titleLabel?.font = UIFont(name: self.fontNameBold, size: 14)
        addAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAction.button.backgroundColor = self.snorkelBlueColor
        addAction.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        addAction.button.addTarget(self, action: #selector(self.addItem(_:)), forControlEvents: .TouchUpInside)

        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addItem(sender: UIButton) {
        
        let newItem = ItemModel(name: self.newItemTextField!.text!, isHidden: false)
        self.allItems.append(newItem)
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow(self.allItems.count - 1, inComponent: 0, animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showRemoveConfirmationAlert(sender: UIButton) {
    
        let selectedRow = self.pickerView.selectedRowInComponent(0)
        let selectedItemName = self.allItems[selectedRow].name
        
        let alert = SimpleAlert.Controller(title: "Deseja mesmo remover", message: selectedItemName, style: .Alert)
        
        alert.configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.textColor = self?.snorkelBlueColor
                view.titleLabel.font = UIFont(name: self!.fontNameBold, size: 20)
                view.messageLabel.textColor = self?.snorkelBlueColor
                view.messageLabel.font = UIFont(name: self!.fontName, size: 18)
                view.backgroundColor = UIColor.whiteColor()
            }
        }
        
        alert.configContainerCornerRadius = {
            return self.defaultRadius * 2
        }
        
        let cancelAction = SimpleAlert.Action(title: "Cancelar", style: .Cancel)
        let deleteAction = SimpleAlert.Action(title: "SIIIIM", style: .OK)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        cancelAction.button.titleLabel?.font = UIFont(name: self.fontNameBold, size: 14)
        cancelAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelAction.button.backgroundColor = self.snorkelBlueColor
        
        deleteAction.button.titleLabel?.font = UIFont(name: self.fontNameBold, size: 14)
        deleteAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        deleteAction.button.backgroundColor = self.snorkelBlueColor
        deleteAction.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        deleteAction.button.addTarget(self, action: #selector(self.removeItem(_:)), forControlEvents: .TouchUpInside)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func removeItem(sender: UIButton) {
        
        let selectedRow = self.pickerView.selectedRowInComponent(0)
        self.allItems.removeAtIndex(selectedRow)
        self.pickerView.reloadAllComponents()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func hideItem(sender: UIButton) {
        
        
    }
    
    @IBAction func endEdition(sender: UIButton) {
        
        self.addButton.hidden = true
        self.deleteButton.hidden = true
        self.hideButton.hidden = true
        self.okButton.hidden = true
        self.editButton.hidden = false
        self.randomizeButton.enabled = true
        self.resultLabel.enabled = true
    }
    
    
//------------------------------
//MARK: Pickerview
//------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allItems.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let item = self.allItems[row]
        let font = UIFont(name: self.fontName, size: 14)
        let color = UIColor.darkGrayColor()
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = color
        pickerLabel.text = item.name
        pickerLabel.font = font
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}


//------------------------------
