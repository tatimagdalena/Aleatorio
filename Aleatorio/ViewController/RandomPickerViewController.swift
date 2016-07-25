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
    let fontName: String = "KannadaSangamMN"
    let fontNameBold: String = "KannadaSangamMN-Bold"
    let snorkelBlueColor: UIColor = UIColor(red: 11/255.0, green: 80/255.0, blue: 130/255.0, alpha: 1.0)
    let defaultRadius: CGFloat = 8.0
    var allItems: [ItemModel]!
    var hiddenIndexes: [Int]!
    
    var newItemTextField: UITextField?
    
    
//------------------------------
//MARK: Lifecycle
//------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("FirstAccess") == nil {
            //first access
            self.createItems()
            defaults.setBool(false, forKey: "FirstAccess")
        }
        
        self.allItems = ItemModel.findAll() as! [ItemModel]
        self.getHiddenIndexes()
        
        self.pickerView.selectRow(self.allItems.count/2, inComponent: 0, animated: false)
        
        self.endEdition(self.editButton)
        
        //let selectedRow = self.pickerView.selectedRowInComponent(0)
        //let selectedItemView = self.pickerView.viewForRow(selectedRow, forComponent: 0) as! PickerItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//------------------------------
//MARK: Data
//------------------------------
    
    func createItems() {
        
//        let item1 = ItemModel(name: "Frango à Parmegiana", isHidden: false)
//        let item2 = ItemModel(name: "BK", isHidden: false)
//        let item3 = ItemModel(name: "Zaitune", isHidden: false)
//        let item4 = ItemModel(name: "Dioguinho", isHidden: false)
//        let item5 = ItemModel(name: "Costelo", isHidden: false)
//        let item6 = ItemModel(name: "Beco", isHidden: false)
//        let item7 = ItemModel(name: "Conexão", isHidden: false)
//        let item8 = ItemModel(name: "Toledo", isHidden: false)
//        let item9 = ItemModel(name: "Galeto Castelo", isHidden: false)
        
        let item1 = ItemModel.create()
        item1.name = "Frango à Parmegiana"
        item1.isHidden = false
        item1.save()
        let item2 = ItemModel.create()
        item2.name = "BK"
        item2.isHidden = false
        item2.save()
        let item3 = ItemModel.create()
        item3.name = "Zaitune"
        item3.isHidden = false
        item3.save()
        let item4 = ItemModel.create()
        item4.name = "Dioguinho"
        item4.isHidden = false
        item4.save()
        let item5 = ItemModel.create()
        item5.name = "Costelo"
        item5.isHidden = false
        item5.save()
        let item6 = ItemModel.create()
        item6.name = "Beco"
        item6.isHidden = false
        item6.save()
        let item7 = ItemModel.create()
        item7.name = "Conexão"
        item7.isHidden = false
        item7.save()
        let item8 = ItemModel.create()
        item8.name = "Toledo"
        item8.isHidden = false
        item8.save()
        let item9 = ItemModel.create()
        item9.name = "Galeto Castelo"
        item9.isHidden = false
        item9.save()
        
        
        //self.allItems = [item1, item2, item3, item4, item5, item6, item7, item8, item9]
    }
    
    func getHiddenIndexes() {
        
        self.hiddenIndexes = []
        
        for item in self.allItems {
            
            let isHidden = item.isHidden?.boolValue
            if isHidden! {
                self.hiddenIndexes.append(self.allItems.indexOf(item)!)
            }
        }
    }
    
//------------------------------
//MARK: Buttons actions
//------------------------------
    
    @IBAction func randomizeSelection(sender: UIButton) {
        
        //let itemsAmount = Int(self.allItems.count)
        //let random = Int(arc4random_uniform(itemsAmount))
        
        let itemsIndexes = (0...self.allItems.count-1)
        let randomResult = itemsIndexes.random(without: self.hiddenIndexes)
        
        self.resultLabel.text = allItems[randomResult].name
        self.pickerView.selectRow(randomResult, inComponent: 0, animated: true)
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
        
        //let newItem = ItemModel(name: self.newItemTextField!.text!, isHidden: false)
        let newItem = ItemModel.create()
        newItem.name = self.newItemTextField!.text!
        newItem.isHidden = false
        newItem.save()
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
        
        let item = self.allItems[selectedRow]
        item.delete()
        
        self.allItems.removeAtIndex(selectedRow)
        self.pickerView.reloadAllComponents()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func hideItem(sender: UIButton) {
        
        let selectedRow = self.pickerView.selectedRowInComponent(0)
        let item = self.allItems[selectedRow]
        let isHidden = item.isHidden?.boolValue

        if isHidden! {
            
            let indexToRemove = self.hiddenIndexes.indexOf(selectedRow)
            self.hiddenIndexes.removeAtIndex(indexToRemove!)
            self.hideButton.setImage(UIImage(named: "visible"), forState: .Normal)
            self.allItems[selectedRow].isHidden = false
            
        }
        else {
            
            self.hiddenIndexes.append(selectedRow)
            self.hideButton.setImage(UIImage(named: "invisible"), forState: .Normal)
            self.allItems[selectedRow].isHidden = true
        }
        
        self.allItems[selectedRow].save()
        self.pickerView.reloadAllComponents()
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
        
        let pickerLabel = UILabel()
        pickerLabel.text = item.name
        pickerLabel.font = font
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        let isHidden = item.isHidden?.boolValue
        if isHidden! {
            //pickerLabel.enabled = false
            pickerLabel.textColor = UIColor.lightGrayColor()
            pickerLabel.alpha = 0.5
        }
        else {
            //pickerLabel.enabled = true
            pickerLabel.textColor = UIColor.blackColor()
            pickerLabel.alpha = 1.0
        }
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let isHidden = self.allItems[row].isHidden!.boolValue
        
        if isHidden {
            self.hideButton.setImage(UIImage(named: "invisible"), forState: .Normal)
        }
        else {
            self.hideButton.setImage(UIImage(named: "visible"), forState: .Normal)
        }
    }
}


//------------------------------
