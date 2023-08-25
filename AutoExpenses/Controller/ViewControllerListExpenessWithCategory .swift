//
//  ViewControllerListExpenessWithCategory.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/07/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol DelegateCategory {
    func setCategory(category: BaseCategory)
}

class ViewControllerListExpenessWithCategory: ViewControllerThemeColor, DelegateShowViewController {
    
    var structDate: StructDateForSelect {
        return StructDateForSelect(year: (SelectedDate.shared.getDate()[.YearString] as! String).toInt(), month: SelectedDate.shared.getSelectedIndexMonth())
    }
    
    private var modelSchedule: ModelSchedule?
    private var dataForCalculation: CalculationForCategory?
    private var arrayDictonaryItemCategory: [[BaseCategory]]?
    private var arrayDataFromCategory: [DataForSchedule]?
    
    private var viewBackForColor: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var labelCategory: UILabel!
    @IBOutlet private weak var buttonAdd: UIButton!
    
    
    deinit {
        print("deinit ViewControllerListExpenessWithCategory")
        manager = nil
        modelSchedule = nil
        dataForCalculation = nil
        arrayDictonaryItemCategory?.removeAll()
        arrayDataFromCategory?.removeAll()
        viewBackForColor.removeFromSuperview()
        viewBackForColor = nil
    }
    
    var manager: ManagerCategory! {
        didSet {
            updateArrayItemFromCategory(_category: manager.category!)
        }
    }
    
    
    
    @objc private func addExpense() {
        self.manager.category?.delegateShowViewController = self
        self.manager.category!.click(typeView: .Additional)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) {
            self.viewBackForColor.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tableView.frame.origin.y - (scrollView.contentOffset.y))
        }
    }
    
    
    private func updateArrayItemFromCategory(_category: BaseCategory) {
        
        if self.arrayDataFromCategory == nil {
            self.arrayDataFromCategory = [DataForSchedule]()
        }
        
        arrayDataFromCategory?.removeAll()
        for i in 0..<manager.getCount(year_month: structDate) {
            let data = manager.getDataBaseToIndex(index: i, year_month: structDate)
            arrayDataFromCategory?.append(DataForSchedule(point: data.dateField?.date, value: data.sumField!.sum))
        }
        modelSchedule = ModelSchedule(arrayDataForSchedule: arrayDataFromCategory!)
        modelSchedule?.delegate = self
        self.dataForCalculation = CalculationForCategory(category: _category, period: structDate)
        self.arrayDictonaryItemCategory = getArrayDictonaryItemCategory().sorted(by: {$0[0].dateField!.date! > $1[0].dateField!.date!})
        
        if tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    private func getArrayDictonaryItemCategory() -> [[BaseCategory]] {
        var tempArray = [BaseCategory]()
        
        for i in 0..<manager.getCount(year_month: structDate) {
            let data = manager.getDataBaseToIndex(index: i, year_month: structDate)
            tempArray.append(data)
        }

        let crossReference = Dictionary(grouping: tempArray, by: {Calendar.current.component(.month, from: $0.dateField!.date!)})
        
        var arrayArrays = [[BaseCategory]]()
        
        for (_ , value) in crossReference {
                arrayArrays.append(value)
        }
        
        return arrayArrays
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.buttonAdd.addTarget(self, action: #selector(addExpense), for: .touchUpInside)
        self.viewBackForColor = UIView()
        self.view.insertSubview(self.viewBackForColor, at: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.viewBackForColor.backgroundColor = manager.category?.colorHead
        labelCategory.text = manager.category?.headerField
        
        self.viewBackForColor.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.tableView.frame.origin.y)
        
        self.updateArrayItemFromCategory(_category: self.manager.category!)
        modelSchedule?.update()
        
        //TODO: Analytic
        AnalyticEvents.logEvent(.OpenListExpenses)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func showViewController(vc: UIViewController) {
//        self.manager = ManagerCategory(category: category ?? Fuel())
        self.navigationController!.pushViewController(vc, animated: true)
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
extension ViewControllerListExpenessWithCategory: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDictonaryItemCategory!.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = manager.getCount(year_month: self.structDate) 
        
        if count <= 0 {
            self.backButton(UIButton())
        }
        
        return section > 0 ? arrayDictonaryItemCategory![section - 1].count : (manager.category is Fuel ? 3 : 2)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            return UIView()
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
        view.backgroundColor = .white
        
        let label = UILabel(frame: view.bounds)
        label.frame.origin.x = 16
        label.backgroundColor = .white
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 22)

        let formatter = DateFormatter()
        let month = formatter.standaloneMonthSymbols![Calendar.current.component(.month, from: arrayDictonaryItemCategory![section-1][0].dateField!.date!)-1].capitalizingFirstLetter()

        label.text = month
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let typeDateSelect: ViewScheduleLinear.TypeVisual =  SelectedDate.shared.getSelectedIndexMonth() == 0 ? .toMonth : .todDay
        return typeDateSelect == .toMonth && section > 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    // свайп удаление расходов
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCellCategory {
            if (cell as TableViewCellCategory).isEmptyExpenses {
                return UISwipeActionsConfiguration(actions: [])
            }
        }
        
        let delete = UIContextualAction(style: .destructive, title:  "Удалить", handler: {(ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
            self.deleteActionSwipe(indexPath: indexPath, complete: { (state) in
                success(state)
            })
        })
        delete.image = UIImage(named: "iconDelete")
        delete.backgroundColor = UIColor.init(rgb: 0xEE5656)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    
    func deleteActionSwipe(indexPath: IndexPath, complete: @escaping (Bool) -> Void) {
        
        var messageAlert = ""
        messageAlert = "Удалить текущие данные?"
        
        let alert = UIAlertController(title: "Удаление", message: messageAlert, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .destructive) {(UIAlertAction) in
            
            let category = self.arrayDictonaryItemCategory![indexPath.section-1][indexPath.row]
            self.manager.deleteDataBaseFindToDate(date: category.dateField!.date!)
            
            //TODO: Analytic
            AnalyticEvents.logEvent(.DeletedExpense, params: ["DateExpense" : category.dateField?.date?.toString() ?? "No date"])
            
            LocalDataSource.statisticViewController.update = true
        
            let count = self.manager.getCount(year_month: self.structDate)
            
            if count <= 0 {
                self.backButton(UIButton())
            }
            
            complete(true)
        
            if count > 0 {
                self.updateArrayItemFromCategory(_category: category)
                self.modelSchedule?.update()
            }
            
        }
        
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { (UIAlertAction) in
            complete(false)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 80
            case 1:
                let typeDateSelect: ViewScheduleLinear.TypeVisual = SelectedDate.shared.getSelectedIndexMonth() == 0 ? .toMonth : .todDay
                let array = sortArrayToDateType(dataForScheludeArray: arrayDataFromCategory!, _type: typeDateSelect)
                return array.count > 1 ? 100 : 0
            case 2:
                return 75
            default:
                return 0
            }
        }
        return 65.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let typeDateSelect: ViewScheduleLinear.TypeVisual = SelectedDate.shared.getSelectedIndexMonth() == 0 ? .toMonth : .todDay
        
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDataExpenses") as! TableViewCellExpenses
            let category = arrayDictonaryItemCategory![indexPath.section-1] [indexPath.row]
            let _manager = ManagerCategory(category: category)
            cell.initialization(category: _manager.category!, delegate: self)
            
            return cell
        } else {
            switch indexPath.row {
// TODO: данные о выбраном промежутке времени и общая сумма
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellDataWithListExpenses") as! TableViewCellDataWithListExpenses
                
                let cost = manager.getAllSum(year_month: self.structDate).roundTo(places: 0).formattedWithSeparator
                cell.initialization(color: self.manager.category!.colorHead, type: typeDateSelect, cost: cost, structDate: structDate)
                return cell
                
// TODO: график
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellSchedule") as! TableViewCellSchedule
                let array = sortArrayToDateType(dataForScheludeArray: arrayDataFromCategory!, _type: typeDateSelect)
                cell.initialization(array: array, color:self.manager.category!.colorHead, type: typeDateSelect)
                return cell
                
// TODO: полезные расчеты для владельца авто
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellCalculation") as! TableViewCellCalculation
                cell.initialization(calculateCategory: dataForCalculation!, color: self.manager.category!.colorHead)
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }

    
    private var checkOverlapDate: Bool {
        let expense = arrayDataFromCategory![0]
        var overlap = false
        for exp in arrayDataFromCategory! {
            if Calendar.current.component(.day, from: expense.point!) != Calendar.current.component(.day, from: exp.point!) {
                overlap = true
                break
            }
        }
        return overlap
    }
    
    private func sortArrayToDateType(dataForScheludeArray: [DataForSchedule], _type: ViewScheduleLinear.TypeVisual) -> [DataForSchedule] {

                var tempDataForScheludeArray = [DataForSchedule]()
                
                let groupSorted = dataForScheludeArray.sorted(by: {$0.point! > $1.point!}).groupSort(byDate: {($0).point!})
                let arrayArrays = NSMutableArray(array: groupSorted)
                    
                for array in arrayArrays {
                    var newElem: DataForSchedule?
                    for item: DataForSchedule in array as! [DataForSchedule] {
                        
        //                if type == .todDay {
                            if newElem == nil {
                                newElem = DataForSchedule(point: item.point, value: item.value)
                            } else {
                                newElem?.value! += item.value!
                            }
        //                } else {
        //
        //                }
                    }
                    tempDataForScheludeArray.append(newElem!)
                }
                
        if _type == .toMonth {
                        let crossReference = Dictionary(grouping: tempDataForScheludeArray, by: {Calendar.current.component(.month, from: $0.point!)})
            
                        var arr = [DataForSchedule]()
        
                        for (_ , value) in crossReference {
                            var cost: Float = 0
                            var date = value[0]
                            for dateSchedule in value {
                                date = dateSchedule
                                cost += dateSchedule.value!
                            }
                            arr.append(DataForSchedule(point: date.point!, value: cost))
                        }
        
                       tempDataForScheludeArray = arr
                    }
                
             return tempDataForScheludeArray.sorted(by: {$0.point! < $1.point!})
    }
}

extension ViewControllerListExpenessWithCategory: DelegateDataToSchedule {
    
    func setData(forSchedule: [DataForSchedule]) {
         self.arrayDictonaryItemCategory = getArrayDictonaryItemCategory().sorted(by: {$0[0].dateField!.date! > $1[0].dateField!.date!})
         
         if tableView != nil {
             self.tableView.reloadData()
         }
    }
    
}
