//
//  ParsingJSON.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 25.10.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import Foundation

class ParsingJSON {
    
    private var nameFile: String?
    
    init(nameFile: String) {
        self.nameFile = nameFile
    }
    
    func getDataFromJson(key: String) -> Any? {
          
        let url = Bundle.main.url(forResource: nameFile, withExtension: "json")
        guard let jsonData = url else { return nil }
        guard let data = try? Data(contentsOf: jsonData) else { return nil}
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
    
        if let dictionary = json as? [String: Any] {
            return dictionary[key]
        }
        return nil
    }
    
}
