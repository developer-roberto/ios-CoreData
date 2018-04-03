//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Roberto Oliveira on 02/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    // MARK: - Properties
    private var consolesManager:ConsolesManager = ConsolesManager.shared
    var game:Game!
    private var selectedConsole:Console?
    private lazy var pickerView:UIPickerView = {
        let vw = UIPickerView()
        vw.dataSource = self
        vw.delegate = self
        vw.backgroundColor = UIColor.white
        return vw
    }()
    
    
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var txfTitle: UITextField!
    @IBOutlet weak var txfSubtitle: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btnCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    
    
    
    // MARK: - IBActions
    @IBAction func coverAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        if self.game == nil {
            self.game = Game(context: self.context)
        }
        self.game.title = self.txfTitle.text
        self.game.releaseDate = self.dpReleaseDate.date
        self.game.console = self.selectedConsole
        self.game.cover = self.ivCover.image
        do {
            try self.context.save()
        } catch {
            print("Something went wrong: ", error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Methods
    private func prepareConsoleTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btnCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(AddEditViewController.cancelMethod))
        let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEditViewController.doneMethod))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btnCancel, space,btnDone]
        self.txfSubtitle.inputAccessoryView = toolbar
        self.txfSubtitle.inputView = self.pickerView
    }
    
    private func prepareTitleTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEditViewController.cancelMethod))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [space,btnDone]
        self.txfTitle.inputAccessoryView = toolbar
    }
    
    @objc func cancelMethod() {
        self.txfTitle.resignFirstResponder()
        self.txfSubtitle.resignFirstResponder()
    }
    
    @objc func doneMethod() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        let item = self.consolesManager.consoles[row]
        self.selectedConsole = item
        self.txfSubtitle.text = item.title
        self.txfSubtitle.resignFirstResponder()
    }
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.consolesManager.loadConsoles(with: self.context)
        self.prepareConsoleTextField()
        self.prepareTitleTextField()
        if let item = self.game {
            self.txfTitle.text = item.title
            if let console = item.console, let index = self.consolesManager.consoles.index(of: console) {
                self.selectedConsole = console
                self.txfSubtitle.text = console.title
                self.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            self.title = "Edit Game"
            self.btnConfirm.setTitle("UPDATE", for: .normal)
            self.ivCover.image = item.cover as? UIImage
            if let date = item.releaseDate {
                self.dpReleaseDate.date = date
            }
            if item.console != nil {
                self.btnCover.setTitle(nil, for: .normal)
            }
        }
    }
    
}




extension AddEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = self.consolesManager.consoles[row]
        return item.title
    }
    
}


extension AddEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.ivCover.image = image
        self.btnCover.setTitle(nil, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
}


