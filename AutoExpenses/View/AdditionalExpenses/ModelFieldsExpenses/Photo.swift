//
//  PhotoView.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 18/03/2019.
//  Copyright © 2019 rx. All rights reserved.
//

import UIKit

// MARK: класс Model для добавления фото
class Photo: BaseAutoInfo  {
    
    var arrayPhotos: [Data]?
    
    override init() {
        super.init()
        self.arrayPhotos = [Data]()
        self.arrayPhotos?.removeAll()
        self.heightFields = 152
        self.id = "Photo"
        self.headerField = "Фотография"
        self.icon = UIImage(named: "new_photo")
    }
 
    
    func dataImages() -> [Data] {
        return arrayPhotos!
    }
    
    deinit {
        self.arrayPhotos?.removeAll()
        self.arrayPhotos = nil
    }
    
    func openForShow() {
        
    }
    
    
    
    override func isEmpty() -> Bool {
        return dataImages().count <= 0
    }
    

    
}

