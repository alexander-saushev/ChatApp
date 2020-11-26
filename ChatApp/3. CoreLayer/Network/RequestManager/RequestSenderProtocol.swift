//
//  RequestSenderProtocol.swift
//  ChatApp
//
//  Created by Александр Саушев on 18.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum ApiError: Error {
    case stringCantBeParsed, dataCantBeParsed
    case taskError
}

protocol IRequestSender {
    func send<Parser>(pageNumber: Int?,
                      requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, ApiError>) -> Void)
}
