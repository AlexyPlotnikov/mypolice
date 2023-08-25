//
//  TableViewCellServiceForSelect.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 11.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func contentDidChange(cellSettings: CellSettings)
    func writeService(idService: String?)
}

class TableViewCellServiceForSelect: UITableViewCell {
    
    @IBOutlet weak private var iconStation: UIImageView!
    @IBOutlet weak private var labelHeader: UILabel!
    @IBOutlet weak private var viewPlayer: ViewPlayerForVideo!
    @IBOutlet weak private var viewLike: ViewLike!
    @IBOutlet weak private var buttonWrite: UIButton!
    @IBOutlet private var arrayLabelsAddress: [UILabel]!
    
    private var viewMap: UIImageView!
    private var viewDecription: ViewDescriptionStation!
    private var buttonPhone: ButtonCallNumber!
    private var viewAddress: ViewSimpleIconAndLabel!
    private var modelService: ModelService?
    private var showFull: Bool = false
    
    private weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonWrite.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
    }
    
    func setup (modelService: ModelService, delegate: CellDelegate) {
        if self.modelService == nil {
            self.modelService = modelService
            self.delegate = delegate
            
            self.layer.cornerRadius = 12
            self.layer.masksToBounds = true
            self.clipsToBounds = true

            iconStation.image = self.modelService!.logo
            labelHeader.text = self.modelService!.nameService
            
            buttonPhone = ButtonCallNumber(frame: CGRect.zero, imageSetting: (UIImage(named: "phone")!, nil), arrayNumbers: modelService.numbersPhones, vc: self.delegate as! UIViewController)
            self.addSubview(buttonPhone!)
            
            viewAddress = ViewSimpleIconAndLabel(frame: CGRect.zero, imageSetting: (UIImage(named: "locationIcon")!, UIColor.init(rgb: 0xB0B8C8)), text: modelService.location.address)
            self.addSubview(viewAddress!)
          
            viewDecription = ViewDescriptionStation(longDescription: self.modelService!.fullDescription, shortDescription: self.modelService!.shortDescription, delegate: self)
            self.addSubview(viewDecription!)
            
            viewMap = UIImageView()
            viewMap.contentMode = .scaleAspectFill
            viewMap.image = UIImage(named: (modelService.id == "Авториеки Бол,125/3" ? "mao" : "map"))
            viewMap.backgroundColor = .lightGray
            self.addSubview(viewMap!)
            
            for label in arrayLabelsAddress {
                label.text = self.modelService!.location.address
            }
            
            viewPlayer.configure(view: (delegate as! UIViewController).view)
            viewPlayer.isLoop = true
        }
    }
    
    func controllPlaying(play: Bool)  {
        if viewPlayer.isPlaying != play {
            viewPlayer.isPlaying = play
        }
    }
    
    @objc private func actionButton() {
        delegate?.writeService(idService: modelService?.id)
    }

    
    func setShowState(state: Bool) {
        showFull = state
        delegate?.contentDidChange(cellSettings: CellSettings(cell: self, height: getHeight()))
    }
    
    
    private func getHeight() -> CGFloat {
        let full = 746.toCGFloat()
        let small = viewPlayer.frame.height + viewLike.frame.height + buttonWrite.frame.height + viewDecription.frame.height + 8
        return showFull ? full : small
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func getPointUpVideo() -> CGFloat {
        return self.viewPlayer.frame.origin.y
    }
    
    func getPointDownVideo() -> CGFloat {
        return self.viewPlayer.frame.origin.y + self.viewPlayer.frame.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        viewDecription.setNeedsLayout()
      
        viewDecription.frame = CGRect(x: 11, y: viewLike.frame.origin.y + viewLike.frame.height + 8, width: self.frame.width - 22, height: viewDecription.frame.height)
         
        
         buttonPhone.frame = CGRect(origin: CGPoint(x: 0, y: viewDecription.frame.origin.y + viewDecription.frame.height),
                                    size: CGSize(width: self.frame.width, height: showFull ? 34 : 0))
         
         viewAddress.frame = CGRect(origin: CGPoint(x: 0, y: buttonPhone.frame.origin.y + buttonPhone.frame.height),
                                           size: buttonPhone.frame.size)
         
         let startPointMapY = viewAddress.frame.origin.y + viewAddress.frame.height
            self.viewMap.frame = CGRect(x: 0,
                                        y: startPointMapY,
                                    width: self.frame.width,
                                    height: self.showFull ? buttonWrite.frame.origin.y - startPointMapY : 0)
         
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setShowState(state: showFull)
        
        self.contentView.layoutMargins.left = 16
        self.contentView.layoutMargins.right = 16
    }

}

extension TableViewCellServiceForSelect: DelegateStateDesciptionForStation {
  
    
    var show: Bool {
        get {
            return showFull
        }
        set (_show) {
            setShowState(state: _show)
        }
    }
    
        
}
