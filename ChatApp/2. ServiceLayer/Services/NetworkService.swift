//
//  NetworkService.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

protocol INetworkService {
    func getImageUrls(pageNumber: Int?, completionHandler: @escaping ([Images]?, String?) -> Void)
    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}

class NetworkService: INetworkService {
    private let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }

    func getImageUrls(pageNumber: Int?, completionHandler: @escaping ([Images]?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageURLConfig()

        loadImageURL(pageNumber: pageNumber, requestConfig: requestConfig, completionHandler: completionHandler)
    }

    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageConfig(imageUrl: imageUrl)

        loadImage(requestConfig: requestConfig, completionHandler: completionHandler)
    }

    private func loadImageURL(pageNumber: Int?,
                              requestConfig: RequestConfig<ImageURLParser>,
                              completionHandler: @escaping ([Images]?, String?) -> Void) {
        requestSender.send(pageNumber: pageNumber, requestConfig: requestConfig) { (result: Result<[Images], ApiError>) in

            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }

    private func loadImage(requestConfig: RequestConfig<ImageParser>,
                           completionHandler: @escaping (UIImage?, String?) -> Void) {
        requestSender.send(pageNumber: nil, requestConfig: requestConfig) { (result: Result<UIImage, ApiError>) in

            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
