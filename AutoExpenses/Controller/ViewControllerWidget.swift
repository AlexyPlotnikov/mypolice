//
//  ViewControllerWidget.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 19/06/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

class ViewControllerWidget: ViewControllerThemeColor {
    
    var userInformationHandler: UserInformationHandler?
    var indexPathElementSelect: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(array: [IAddInfoProtocol], keyID: String) {
        userInformationHandler = nil
        userInformationHandler = UserInformationHandler(array: array, keyID: keyID)
    }
    
}

//MARK: DragDelegate
extension ViewControllerWidget: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
    
        let previewParameters = UIDragPreviewParameters()
        let cell = tableView.cellForRow(at: indexPath)
        previewParameters.visiblePath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius:0)
        previewParameters.backgroundColor = .white
        return previewParameters
    }
    
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
    
        let dragItem = self.dragItem(forPhotoAt: indexPath, tableview:tableView)
        UISelectionFeedbackGenerator().selectionChanged()
        return indexPath.section == 0 ? [dragItem] : []
    }
    
    func dragItem(forPhotoAt indexPath: IndexPath, tableview: UITableView) -> UIDragItem {
        let string = indexPath.section == 0 ? userInformationHandler!.getSelectedElementsInfo()[indexPath.row].id : ""
        let itemProvider = NSItemProvider(object: string as! NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return dragItem
    }
}

//MARK: DropDelegate
extension ViewControllerWidget: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        let cell = tableView.cellForRow(at: indexPath)
        previewParameters.visiblePath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: 0)
        previewParameters.backgroundColor = .white
        UISelectionFeedbackGenerator().selectionChanged()
        return previewParameters
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
  
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                if destinationIndexPath?.section ?? 1 == 0 {
                 
                    if self.indexPathElementSelect == nil || self.indexPathElementSelect != destinationIndexPath {
                        self.indexPathElementSelect = destinationIndexPath
                        UISelectionFeedbackGenerator().selectionChanged()
                    }else {
                        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                    }
                }
                return UITableViewDropProposal(operation: .forbidden, intent: .insertIntoDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        
        let destinationIndexPath: IndexPath

        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.section != 0 {
                return
            }
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections-1 
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [String]
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.userInformationHandler!.insertItemInNewPosition(item as! IAddInfoProtocol, index)
                indexPaths.append(indexPath)
            }
            if indexPaths != tableView.indexPathsForVisibleRows {
                tableView.insertRows(at: indexPaths, with: .middle)
            }
        }
    }
}
