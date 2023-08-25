//
//  CacheManager.swift
//  AutoExpenses
//
//  Created by Иван Зубарев on 12.11.2019.
//  Copyright © 2019 rx. All rights reserved.
//

import AVFoundation
import Foundation


public enum Result<T> {
    case success(T)
    case failure(NSError)
    case undefined(URL)
}


class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)

        //return file path if already exists in cache directory
        if !fileManager.fileExists(atPath: file.path) {
            completionHandler(Result.undefined(URL(string: stringUrl)!))
        } else {
            completionHandler(Result.success(file))
            return
        }

        DispatchQueue.global().async {
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                DispatchQueue.main.async {
                    completionHandler(Result.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(NSError()))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
}
