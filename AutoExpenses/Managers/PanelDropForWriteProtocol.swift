//
//  PanelDropForWriteProtocol.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 04.12.2019.
//  Copyright © 2019 rx. All rights reserved.
//

protocol PanelDropForWriteProtocol {
    func show(complete: (() -> Void)?)
    func close(complete: (()->Void)?)
}
