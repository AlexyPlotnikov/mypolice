//
//  ViewControllerTableViewExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 07/08/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerTableViewExpenses: ViewControllerThemeColor {
    
    @IBOutlet weak var constreintTableBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var structDate: StructDateForSelect {
        return StructDateForSelect(year: (SelectedDate.shared.getDate()[.YearString] as! String).toInt(), month: SelectedDate.shared.getSelectedIndexMonth())
    }
    
    private var managerCategory: ManagerCategory!
    private var heightViewForBias: CGFloat = 0

    
    var arrayToField: [IFieldInfo]?
    var category : BaseCategory! {
        didSet {
            if self.arrayToField != nil && self.arrayToField!.count > 0 {
                self.tableView.reloadData()
            }
        }
        
        willSet (_category) {
            if _category == nil {
                return
            }
            
            self.managerCategory = ManagerCategory(category: _category)
            switch self.managerCategory.category! {
            case is Fuel:
                (_category as! Fuel).updateInfo()
                self.arrayToField = [_category.sumField!,
                                     _category.mileageField!,
                                     (_category as! Fuel).priceLiterField,
                                     _category.dateField!,
                                     _category.commentField,
                                     _category.photo!] as? [IFieldInfo]
                
            case is CarWash, is Parking, is Parts, is  Tuning, is Other, is Policy:
                self.arrayToField = [_category.sumField!,
                                    // _category.mileageField!,
                                     _category.dateField!,
                                     _category.commentField,
                                     _category.photo!] as? [IFieldInfo]
                
            case is TechnicalService:
                self.arrayToField = [_category.sumField!,
                                   //  _category.mileageField!,
                                     (_category as! TechnicalService).technicalService,
                                     _category.dateField!,
                                     _category.commentField,
                                     _category.photo!] as? [IFieldInfo]
            
            default:
                self.arrayToField?.removeAll()
                self.arrayToField = nil
            }
        }
    }
    
    
    
    func initilization() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification,object: nil)
    }

  deinit {
    print("deinit ViewControllerTableViewExpenses")
        NotificationCenter.default.removeObserver(self)
        category = nil
        self.arrayToField?.removeAll()
        self.arrayToField = nil
        managerCategory = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if category == nil {
            category = Fuel(typeEntity: .EntityFuelCategory)
        }
        
        self.initilization()
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        self.view.addGestureRecognizer(gestureTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.tableView.reloadData()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: managerCategory.category!.typeView == TypeView.Additional ? self.view.frame.width * 0.15 + 8 : 0,
                                                   right: 0)
        updateCountLiter()
    }
    
    // very bad code i am later fix
//    func reloadDateCategory(old: Bool) -> Date?  {
//        for i in 0..<self.arrayToField!.count where self.arrayToField != nil && self.arrayToField?[i] is DataExpenses {
//            if let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as? TableViewCellFieldDateExpenses {
//                print(cell.datePicker!.date)
//                return old ? cell.oldDateForFind! : cell.datePicker!.date
//            }
//        }
//        return nil
//    }
    
    
    func saveExpenses(callback: (_ state: Bool) -> Void) {
        if self.managerCategory.isEmptyField() == nil {
            self.managerCategory.addDataeBase(arrayFields: arrayToField!)
            clearData()
            callback(true)
        } else {
            self.present(self.managerCategory.isEmptyField()!, animated: true, completion: nil)
            callback(false)
        }
    }
    
   
    
    func clearData() {
        
        for i in 0..<arrayToField!.count where arrayToField != nil && arrayToField![i] is Photo {
            
            if let cell = (self.tableView.cellForRow(at: IndexPath(row: i, section: 1)) as? TableViewCellFieldPhotoExpenses) {
                cell.deleteAll()
                cell.removeFromSuperview()
                break
            }
            
            self.tableView.cellForRow(at: IndexPath(row: i, section: 1))?.removeFromSuperview()
        }
        
        self.managerCategory.category!.clearAllField()
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .none, animated: true)
        self.updateCountLiter()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    func deleteExpenses(date: Date) {
        let alert = UIAlertController(title: "Удаление", message: "Хотите удалить расход?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { (UIAlertAction) in
            self.managerCategory.deleteDataBaseFindToDate(date: date)
            self.actionButtonCancel(UIButton())
            LocalDataSource.statisticViewController.update = true
        }
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
  
    //  функция закрытия клавиатуры по нажатию на экран
    @objc private func tapScreen() {
        self.view.endEditing(true)
    }
    
    @objc func actionButtonCancel(_ sender: UIButton) {
        
        if self.managerCategory.getCount(year_month: self.structDate) > 0 {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let vc = (self.parent as? ViewControllerEditionExpenses) {
            vc.checkScrollContentOffset(offsetY: scrollView.contentOffset.y)
        }
    }
    
}
extension ViewControllerTableViewExpenses: DelegateViewExpenses {
    
    func setField(field: IFieldInfo) {
        switch field {
        case is Sum:
            category.sumField = (field as! Sum)
        case is Mileage: category.mileageField = (field as! Mileage)
        case is PricePerLiter:
            (category as! Fuel).priceLiterField = (field as! PricePerLiter)
        case is TechnicalServiceExpenses: (category as! TechnicalService).technicalService = (field as! TechnicalServiceExpenses)
        case is Comment: category.commentField = (field as! Comment)
        case is DataExpenses: category.dateField = (field as! DataExpenses)
        case is Photo:category.photo = (field as! Photo)
        default:
            break
        }
    }
    
    private func updateCountLiter() {
        if (arrayToField ?? []).count <= 0 {
            return
        }
        
        let sum = (arrayToField![0] as! Sum).sum
        if let priceLiterField = (arrayToField![2] as? PricePerLiter) {
            if let cellPrice = (self.tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? TableViewCellFieldPriceLiterExpenses), cellPrice.additionalInfo != nil {
                cellPrice.additionalInfo.text = priceLiterField.price > 0 && sum > 0 ? (sum/priceLiterField.price).roundTo(places: 2).toString(" литров") : ""
            }
        }
    }
    
    // натификашка вызова клавиатуры
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.heightViewForBias = keyboardHeight
        }
    }
    
    func showKeyboard(rect : CGRect) {
    
        UIView.animate(withDuration: 0.2) {
            self.tableView.contentOffset = CGPoint(x: 0,
                                                   y: rect.origin.y)
            
            self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: self.heightViewForBias,
                                                       right: 0)
        }
    }
    
    func hidenKeyboard() {
        UIView.animate(withDuration: 0.2) {
            self.tableView.contentOffset = CGPoint.zero
            self.tableView.contentInset = UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: self.managerCategory.category!.typeView == TypeView.Additional ? self.view.frame.width * 0.15 : 0,
                                                       right: 0)
        }
    }
}


extension ViewControllerTableViewExpenses: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return managerCategory.category!.typeView == TypeView.Editional ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.tableView.frame.width - 16,
                                          height: 35))
        label.frame.origin.x = 16
        label.backgroundColor = .white
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 32)
        label.text = category?.headerField
        view.addSubview(label)

        return section == 0 ? view : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return managerCategory.category!.typeView != TypeView.Editional && UIScreen.main.bounds.width <= 320 ? 0 : 30
        default:
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section < 2 ? arrayToField![indexPath.row].heightFields + 11 : 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return arrayToField?.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section  {
        case 1:
            return getCell(field: arrayToField![indexPath.row])
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEditionDelete") as! TableViewCellSimpleButton
            cell.initialization { [weak self] in
                if let date = self?.category.dateField?.date {
                    self!.deleteExpenses(date: date)
                }
            }
            return cell
        default :
            return UITableViewCell()
        }
    }
    
    func getCell(field: IFieldInfo) -> UITableViewCell {
        
        var cell: UITableViewCell?
        switch field {
        case is Sum:
            let id = managerCategory.category!.typeView == TypeView.Additional ? "cellFieldQR" : "cellField"
            cell = self.tableView.dequeueReusableCell(withIdentifier: id) as! TableViewCellFieldExpenses
            (cell as! TableViewCellFieldExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldExpenses).field.placeholder = field.placeholder ?? ""
            (cell as! TableViewCellFieldExpenses).field.keyboardType = .decimalPad
            (cell as! TableViewCellFieldExpenses).initialization(fieldInfo: field, delegate: self, obligatoryField: true)
            
            if managerCategory.category!.typeView == TypeView.Additional  {
                (cell as! TableViewCellFieldAndQRExpenses).vcToShow = self
            }
            
        case is Mileage:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellField") as! TableViewCellFieldExpenses
            (cell as! TableViewCellFieldExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldExpenses).field.placeholder = field.placeholder ?? ""
            (cell as! TableViewCellFieldExpenses).field.keyboardType = .numberPad
            (cell as! TableViewCellFieldExpenses).initialization(fieldInfo: field, delegate: self, obligatoryField: false)
            
        case is PricePerLiter :
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellFieldPriceLiter") as! TableViewCellFieldPriceLiterExpenses
            (cell as! TableViewCellFieldExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldExpenses).field.placeholder = field.placeholder ?? ""
            (cell as! TableViewCellFieldExpenses).field.keyboardType = .decimalPad
            (cell as! TableViewCellFieldExpenses).initialization(fieldInfo: field, delegate: self, obligatoryField: false)
            
        case is DataExpenses:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellFieldDate") as! TableViewCellFieldDateExpenses
            (cell as! TableViewCellFieldDateExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldDateExpenses).initialization(fieldInfo: field, delegate: self, obligatoryField: false)
            
        case is TechnicalServiceExpenses:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellFieldPickerView") as! TableViewCellPickerViewExpenses
            (cell as! TableViewCellPickerViewExpenses).header.text = field.headerField
            (cell as! TableViewCellPickerViewExpenses).initialization(fieldInfo: field, delegate: self, obligatoryField: false)
            
        case is Comment:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellFieldComment") as! TableViewCellFieldCommentExpenses
            (cell as! TableViewCellFieldCommentExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldCommentExpenses).initialization(fieldInfo: field, delegate: self)
            
        case is Photo:
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellFieldPhoto") as! TableViewCellFieldPhotoExpenses
            (cell as! TableViewCellFieldPhotoExpenses).header.text = field.headerField
            (cell as! TableViewCellFieldPhotoExpenses).initialization(fieldInfo: field, delegate: self)
        default:
            break
        }
        self.updateCountLiter()
        return cell!
    }
    
}


extension ViewControllerTableViewExpenses: DelegateReloadData {
    
    func updateData() {
        updateCountLiter()
    }
}
extension ViewControllerTableViewExpenses: DelegateDataFromQRCode {
    func newExpensesSum(sum: Float, date: Date) {
        
        category!.sumField!.sum = sum
        category!.dateField!.date = date
        tableView.reloadData()
        
        // TODO: Analytics
        AnalyticEvents.logEvent(.AddedNewExpenseFromQRCode, params: ["Category": category!.headerField,
                                                                     "Cost": sum.toString("₽"),
                                                                     "Date": date.toString()])
    }
    
}
