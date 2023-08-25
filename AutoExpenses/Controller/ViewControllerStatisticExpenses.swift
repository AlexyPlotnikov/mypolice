//
//  ViewControllerStatisticExpenses.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 20/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerStatisticExpenses: ViewControllerThemeColor, UIGestureRecognizerDelegate {

    @IBOutlet weak var panelView: CustomCurtainEnterExpenses!
    @IBOutlet weak var backgroundBlack: UIView!
    @IBOutlet weak var viewHeaderScreen: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageEmptyExpenses: UIImageView!
    @IBOutlet weak var viewSave: ViewSave!
    private var viewFunctions: ViewFunctionsForEveryViewController?
    private var viewBlackBackground: UIView?
    
    private var modelAuto = ModelAuto()
    
    private var fullHeight: CGFloat = 234
    private var minHeight: CGFloat = 34
    
    private var viewHeader : UIView?
    private var stateView: Bool = false
    private var touch: Bool = false
    private var modelCurtain: ModelCustomCurtain?
    
    var update: Bool = true
    
    private var chartCircle: IViewControll?
    private var chooseDateController: ChooseDateController?
    private weak var tableViewController: ViewControllerTableViewExpenses?

    private var arrayModels: [ModelSegment] = []
    private var arrayCategory: [BaseCategory] = []
    
    private var manager: ManagerCategory!
    
    private var buttonLockState: UIButton?
    private var stateLock = false {
        willSet (state) {
            self.buttonLockState?.setImage(UIImage(named: !state ? "Unlocked" : "Locked"), for: .normal)
        }
    }
    
    deinit {
        print("deinit_ViewControllerStatisticExpenses")
        manager = nil
        arrayModels.removeAll()
        arrayCategory.removeAll()
        
    }
    
    var structDate: StructDateForSelect {
        print(SelectedDate.shared.getSelectedIndexMonth())
        return StructDateForSelect(year: (SelectedDate.shared.getDate()[.YearString] as! String).toInt(), month: SelectedDate.shared.getSelectedIndexMonth())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if #available(iOS 13.0, *) {
            return modelCurtain != nil && panelView.statePanel != .Top ? .darkContent : .lightContent
        } else {
          return .default
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        touch = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        touch = false
         self.viewBlackBackground?.frame.size.height = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            self.viewBlackBackground?.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.view.frame.width, height: abs(scrollView.contentOffset.y))
        } else {
            self.viewBlackBackground?.frame.size.height = 0
        }
       
        print(scrollView.contentOffset.y)
        
        
        if !touch || isEmptyData() || stateLock {
            return
        }
        
        if scrollView.contentOffset.y > 15 && !stateView {
            stateView = true
            touch = false
            self.updateStatistic()
        } else if scrollView.contentOffset.y < -10 && stateView {
            stateView = false
            touch = false
            self.updateStatistic()
        }
    }

    
    @IBAction func showHeadScreen(_ sender: Any) {
        
        // TODO: Analytics
        AnalyticEvents.logEvent(.OpenAutoInformation)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerHead")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBlackBackground = UIView()
        viewBlackBackground?.backgroundColor = UIColor.init(rgb: 0x111624)
        self.view.addSubview(viewBlackBackground!)
        
        self.update = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        LocalDataSource.statisticViewController = self
        viewHeader = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.width,
                                          height: 0))
        viewHeader?.backgroundColor = UIColor.init(rgb: 0x111624)
        self.buttonLockState = UIButton()
        self.buttonLockState?.addTarget(self, action: #selector(switchBlockerDiagramm), for: .touchUpInside)
        viewHeader!.addSubview(buttonLockState!)
        stateLock = false
        
        self.chooseDateController = ChooseDateController()
        
         let dateSel = ViewDateSelected(clickAction: {
            self.chooseDateController?.showDataPicker()
         })
         self.chooseDateController!.delegateUpdateLabel = dateSel
         self.chooseDateController!.delegateUpdateGraphics = self
        
        let carSel = ViewMyCars(text: modelAuto.info)
        carSel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTextNameCar(_:))))
        
        viewFunctions = ViewFunctionsForEveryViewController(arrayFunctions: [carSel, dateSel])
        viewHeaderScreen!.addSubview(viewFunctions!)
        
        self.updateStatistic()
    }
    
    @objc private func setTextNameCar(_ sender: UIGestureRecognizer) {
        modelAuto.addInfo { (text) in
            (sender.view as! ViewMyCars).labelText?.text = text
        }
    }
    
    @objc private func switchBlockerDiagramm() {
        self.stateLock = !stateLock
    }
    
    @IBAction func openServices(_ sender: Any) {
        
        if !CheckInternetConnection.shared.checkInternet(in: self) {
            return
        }
        
        let vcForShow = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigationServices")
        self.present(vcForShow, animated: true) {
             let entity = EntityAdditionally()
                entity.first = false
                entity.addData()
        }
        
//        let image = UIImage(named: (EntityAdditionally().getAllDataFromDB().count > 0 && EntityAdditionally().getAllDataFromDB()[0].first ? "ServiceFirst" : "Service"))
    }
    
    func getSegmentsCategoryWithoutEmpty() -> [ModelSegment] {
        var arraySegments: [ModelSegment] = []
        
        for category in LocalDataSource.arrayCategory as! [BaseCategory] where ManagerCategory(category: category).getAllSum(year_month: structDate) > 0 {
            manager = ManagerCategory(category: category)
            
            let categorySum: Float = manager.getAllSum(year_month: structDate)
            let sum: String = categorySum.toString()
            arraySegments.append(ModelSegment(color: category.colorHead, value: Float(sum) ?? 0.0))
        }
        arraySegments = arraySegments.sorted(by:{ $0.value > $1.value})
        return arraySegments
    }
    
    
    func isEmptyData() -> Bool {
        return self.arrayModels.count <= 0
    }
    
    func updateStatistic() {
        self.tableView.beginUpdates()
        
        UIView.animate(withDuration: 0) {
            self.viewHeader!.frame = CGRect(x: 0,
                                            y: 0,
                                            width: self.view.frame.width,
                                            height: self.stateView || self.isEmptyData() ? self.minHeight : self.fullHeight)
            
            self.buttonLockState!.frame = CGRect(x: self.viewHeader!.frame.width - (23 + 40),
                                                 y: self.viewHeader!.frame.height - 40,
                                                 width: 40,
                                                 height: 40)
            

            self.tableView.sectionHeaderHeight = self.viewHeader!.frame.height
            self.buttonLockState?.isHidden = self.stateView || self.isEmptyData()
            self.chartCircle?.delete()
            self.chartCircle = nil
            self.chartCircle = AdapterDiagramCircle(in: self.viewHeader!, rect: CGRect(x: 0,
                                                                                       y: 16,
                                                                                       width: self.viewHeader!.bounds.width,
                                                                                       height: self.viewHeader!.bounds.height - 16), segments: self.arrayModels, type: self.stateView || self.isEmptyData()  ? .Line : .Circle)
            self.chartCircle?.create()
            self.tableView.endUpdates()
        }
    }
    
    @objc func switchStatistics() {
       self.stateView = !self.stateView
        updateStatistic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if update {
            self.updateData()
        }
        
        self.modelCurtain?.scrollingToCurCategory()
 
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.modelCurtain == nil {
            self.modelCurtain = ModelCustomCurtain(viewCustom: self.panelView, vc: self)
        }
        
        if let vc = self.children.first as? ViewControllerTableViewExpenses {
            self.tableViewController = vc
        }
        
       
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.panelView.frame.size = self.view.bounds.size
        self.viewFunctions?.frame = CGRect(x: 12, y: 5, width: self.view.frame.width - 12 * 2, height: 40)
        self.modelCurtain?.update()
        
    }
    
}

extension ViewControllerStatisticExpenses : UITableViewDataSource, UITableViewDelegate, DelegateReloadData, DelegateShowViewController {
    
    func showViewController(vc: UIViewController) {
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    func updateData() {
        
        self.update = false
        self.tableViewController!.category.mileageField!.updateInfo()
        self.arrayModels = getSegmentsCategoryWithoutEmpty()
        self.arrayCategory = elementsCategory()
        
        UIView.animate(withDuration: 0.15) {
            self.imageEmptyExpenses.alpha = !self.isEmptyData() ? 0 : 1
        }
        
        self.tableView.alwaysBounceVertical = !isEmptyData()
        
        self.tableView.reloadData()
        updateStatistic()
    
//        self.chooseDateController?.update()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewHeader!.frame.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewHeader
    }
    
    private func elementsCategory() -> [BaseCategory] {
        var array: [BaseCategory] = []

        for item in LocalDataSource.arrayCategory as! [BaseCategory] where ManagerCategory(category: item).getAllSum(year_month: structDate) > 0.0 {
            array.append(item)
        }
        array = array.sorted(by: {ManagerCategory(category: $0).getAllSum(year_month: structDate) > ManagerCategory(category: $1).getAllSum(year_month: structDate)})
        return array
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCategory.count
    }
    
      // свайп удаление расходов
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          
          if let cell = tableView.cellForRow(at: indexPath) as? TableViewCellCategory {
              if (cell as TableViewCellCategory).isEmptyExpenses {
                  return UISwipeActionsConfiguration(actions: [])
              }
          }
          
          let delete = UIContextualAction(style: .destructive, title:  "Удалить", handler: { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
              
              self.deleteActionSwipe(indexPath: indexPath, complete: {(complete) in
                 success(complete)
                  if complete {
                      self.updateData()
                  }
              })
          })
          
          let share = UIContextualAction(style: .normal, title: "Отчет") { (action, view, success: @escaping (Bool) -> Void) in
              let manager = ManagerCategory(category: self.arrayCategory[indexPath.row])
              let export = ExpenssesExportManager(managerCategory: manager, structDate: self.structDate, vc: self)
              export.share()
              success(true)
          }
          
          share.image = UIImage(named: "export")
          delete.image = UIImage(named: "iconDelete")
          delete.backgroundColor = UIColor.init(rgb: 0xEE5656)
          
          return UISwipeActionsConfiguration(actions: [delete,share])
      }

    
    func deleteExpenses(category: BaseCategory) {
      
        manager = ManagerCategory(category: category)
        //TODO: Analytic
        AnalyticEvents.logEvent(.DeletedAllExpensesFromCategory, params: ["Category" : category.headerField])
        
        manager.deleteDataBase(year_month: structDate)
        self.updateData()
    }


    func deleteActionSwipe(indexPath: IndexPath, complete: @escaping (Bool) -> Void) {
        
        var messageAlert = ""
        
        let category = (self.tableView.cellForRow(at: indexPath) as?  TableViewCellCategory)!.category
        
        messageAlert = "Удалить все данные из категории \(category?.headerField ?? "")"
        
        let alert = UIAlertController(title: "Удаление", message: messageAlert, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .destructive) { (UIAlertAction) in
            self.deleteExpenses(category: category!)
            complete(true)
        }
        
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { (UIAlertAction) in
            complete(false)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // делегате создания ячеек таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDataCategory") as! TableViewCellCategory
        var fullValue: Float = 0.0
        for item in self.arrayModels {
            fullValue += item.value
        }
        cell.initialization(category: self.arrayCategory[indexPath.row], vc: self, modelSegment: self.arrayModels[indexPath.row], fullValue: fullValue)
        return cell
    }
    
}
extension ViewControllerStatisticExpenses: DelegateSwipePanelExpenses {
    
    func setStatePanelExpenses(state: ModelCustomCurtain.StatePanelExpenses, valuePointY: CGFloat) {
        
        //TODO: Analytics
        AnalyticEvents.logEvent(.CurtainPosition, params: ["CurtainPosition" : state.rawValue.toString()])
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundBlack.alpha = (state == .Top) ? 0.6 : 0
        }

        if state == .Low {
            self.view.endEditing(true)
//            self.constreintTableStatistic.constant = self.view.frame.height - valuePointY
        }
        
        if state == .Top || state == .Low {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                 self.modelCurtain?.scrollingToCurCategory()
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func savingData() {
        self.tableViewController!.saveExpenses { (save) in
            if save {
                self.panelView?.movePanel(statePanel: .Low)
                self.viewSave.showScreenSave()
                self.updateData()
            }
        }
    }
    
    func setCategory(category: BaseCategory) {
        
        self.tableViewController?.clearData()
        self.tableViewController!.category = category
        self.modelCurtain?.indexCategory = (LocalDataSource.arrayCategory as! [BaseCategory]).firstIndex(where: {(_category) -> Bool in
            category.headerField == _category.headerField
        }) ?? 0
        
        if panelView.statePanel == .Low || panelView.statePanel == .Middle {
            self.tableViewController!.category.mileageField!.updateInfo()
            (tableViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TableViewCellFieldExpenses)?.field.becomeFirstResponder()
        }
    }
}

