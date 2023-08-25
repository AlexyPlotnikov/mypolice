//
//  ViewControllerEditionWidgets.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 30/05/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerEditionWidgets: ViewControllerThemeColor {
    
    @IBOutlet weak var tableView: UITableView!
    var allowMove : Bool = true
    private var countSection = 2
    var userInformationHandler: UserInformationHandler?
    
    weak var delegate : DelegateReloadData?
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.setEditing(true, animated: true)
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        // TODO: Analytics
        AnalyticEvents.logEvent(.EditionWidgets)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .delete : .insert
    }
    
    
    private func cellControll(type: UITableViewCell.EditingStyle, indexPath: IndexPath) {
        switch type {
        case .delete:
            self.userInformationHandler!.removeWidgetFromList(indexPath.row)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .right)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .right)
            tableView.endUpdates()
            
        case .insert:
            let info = self.userInformationHandler!.getNotSelectedElementsInfo()[indexPath.row]
            self.userInformationHandler!.insertItemInNewPosition(info, 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 1)], with: .right)
            tableView.endUpdates()
        default:
            return
        }
        
        let arrayElements = [self.userInformationHandler!.getSelectedElementsInfo(), self.userInformationHandler!.getNotSelectedElementsInfo()]
        
        var num = 0
        for item in arrayElements {
            for j in 0..<item.count {
                (tableView.cellForRow(at: IndexPath(row: j, section: num)) as? TableViewCellEditionWidget)?.header.text = item[j].headerField
            }
            num+=1
        }
        
        self.delegate?.updateData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.cellControll(type: editingStyle, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        
        let place = self.userInformationHandler!.getSelectedElementsInfo()[sourceIndexPath.row]
        self.userInformationHandler!.removeWidgetFromList(sourceIndexPath.row)
        self.userInformationHandler!.insertItemInNewPosition(place, destinationIndexPath.row)
        self.delegate?.updateData()
    }
}

extension ViewControllerEditionWidgets: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.08
    }
}
    

// делегат таблиц
extension ViewControllerEditionWidgets: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? self.userInformationHandler!.getCountElementSelected()  : self.userInformationHandler!.getCountElementNotSelected())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Включенные"
        case 1:
            return "Отключенные"
        default:
            return "Включенные"
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellEdit = tableView.dequeueReusableCell(withIdentifier: "cellEditionWidget") as! TableViewCellEditionWidget
        let info = indexPath.section == 0 ? self.userInformationHandler!.getSelectedElementsInfo()[indexPath.row] : self.userInformationHandler!.getNotSelectedElementsInfo()[indexPath.row]
        cellEdit.header.text = info.headerField

        return cellEdit
    }
}


extension ViewControllerEditionWidgets: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellEditionWidget
        previewParameters.visiblePath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 8)
        return previewParameters
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = self.dragItem(forPhotoAt: indexPath, tableview:tableView)
        self.allowMove = indexPath.section == 0
        return allowMove ? [dragItem] : []
    }
    
    func dragItem(forPhotoAt indexPath: IndexPath, tableview: UITableView) -> UIDragItem {
        let string = indexPath.section == 1 ? self.userInformationHandler!.getNotSelectedElementsInfo()[indexPath.row].id : self.userInformationHandler!.getSelectedElementsInfo()[indexPath.row].id
        
        let itemProvider = NSItemProvider(object: string as! NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return dragItem
    }
}

// делегат поперемещения ячейки
extension ViewControllerEditionWidgets: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                if destinationIndexPath?.section == 0, allowMove {
                    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                }
                
                return UITableViewDropProposal(operation: .forbidden, intent: .insertIntoDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .cancel, intent: .automatic)
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
//            if indexPath.row >= LocalDataSource.headViewController.userInformationHandler!.getCountElementSelected() {
//                return
//            }
            
            destinationIndexPath = indexPath
            
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [String]
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)
                if indexPath.section == 0 {
                    self.userInformationHandler!.insertItemInNewPosition(item as! IAddInfoProtocol, index)
                    self.delegate?.updateData()
                }
                
                indexPaths.append(indexPath)
                
                if indexPaths != tableView.indexPathsForVisibleRows {
                    tableView.insertRows(at: indexPaths, with: .middle)
                }
            }
        }
    }
}

