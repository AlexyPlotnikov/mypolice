//
//  ViewControllerPresenterImage.swift
//  
//
//  Created by Иван Зубарев on 02/08/2019.
//

import UIKit


protocol DelegatePresenterPhoto: NSObject {
    func setImagesArray(arrayImage: [UIImage], indexCurrent: Int)
}

class ViewControllerPresenterImage: ViewControllerThemeColor {


    @IBOutlet weak var backButton: UIButton!
    private var presenter: PresentPhotoFullScreen?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.presenter?.presentPhoto()
         self.view.bringSubviewToFront(self.backButton)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false) {
            self.presenter?.hiddenPhoto()
              self.presenter = nil
        }
    }
}

extension ViewControllerPresenterImage: DelegatePresenterPhoto {
    
    func setImagesArray(arrayImage: [UIImage], indexCurrent: Int) {
        self.presenter = PresentPhotoFullScreen(array: arrayImage,
                                                viewParent: self.view,
                                                indexCurrent: indexCurrent)
    }
}


