//
//  BENetworkManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

final class BENetworkManager: NSObject, URLSessionDataDelegate {

    let session = URLSession(configuration: .default)

    func getData(url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        session.dataTask(with: request)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        } catch {
            print(error.localizedDescription)
        }

    }
}
