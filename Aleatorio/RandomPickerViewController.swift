//
//  RandomPickerViewController.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/20/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import UIKit

class RandomPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    
    let fontName: String = "Kannada Sangam MN"
    let snorkelBlueColor: UIColor = UIColor(red: 11/255.0, green: 80/255.0, blue: 130/255.0, alpha: 1.0)
    let defaultRadius: CGFloat = 8.0
    var items: [String] = ["Frango à Parmegiana", "BK", "Zaitune", "Dioguinho", "Costelo", "Beco", "Conexão", "Toledo", "Galeto Castelo"]
    var newItemTextField: UITextField?
    
    
    
//------------------------------
//MARK: Lifecycle
//------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.selectRow(self.items.count/2, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//------------------------------
//MARK: Buttons actions
//------------------------------
    
    @IBAction func randomizeSelection(sender: UIButton) {
        
        let itemsAmount = UInt32(self.items.count)
        let random = Int(arc4random_uniform(itemsAmount))
        
        self.resultLabel.text = items[random]
        self.pickerView.selectRow(random, inComponent: 0, animated: true)
    }
    
    @IBAction func showAddItemAlert(sender: UIButton) {
        
        let alert = SimpleAlert.Controller(title: "Novo Item:", message: "", style: .Alert)
        
        alert.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            textField.placeholder = "Digite o novo restaurante"
            self.newItemTextField = textField
        }
        
        alert.configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.textColor = UIColor.whiteColor()
                view.titleLabel.font = UIFont(name: self!.fontName, size: 20)
                //view.messageLabel.textColor = UIColor.lightGrayColor()
                //view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
                view.backgroundColor = self!.snorkelBlueColor
                view.textBackgroundView.layer.cornerRadius = self!.defaultRadius
                view.textBackgroundView.clipsToBounds = true
            }
        }
        
        let cancelAction = SimpleAlert.Action(title: "Cancelar", style: .Cancel)
        let addAction = SimpleAlert.Action(title: "Adicionar", style: .OK)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        //cancelAction.button.frame.size.height = 144
        cancelAction.button.titleLabel?.font = UIFont(name: self.fontName, size: 14)
        cancelAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        addAction.button.titleLabel?.font = UIFont(name: self.fontName, size: 14)
        addAction.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addAction.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        addAction.button.addTarget(self, action: #selector(self.addItem(_:)), forControlEvents: .TouchUpInside)

        presentViewController(alert, animated: true, completion: nil)
    }
    
    @objc func addItem(item: String) {
        
        print(self.newItemTextField?.text)
    }
    
    
//------------------------------
//MARK: Pickerview
//------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let item = self.items[row]
        let font = UIFont(name: self.fontName, size: 14)
        let color = UIColor.darkGrayColor()
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = color
        pickerLabel.text = item
        pickerLabel.font = font
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    
    
//------------------------------
//MARK: Navigation
//------------------------------
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
