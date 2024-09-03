//
//  Methods.swift
//  HEIN
//
//  Created by Marco on 2024-09-02.
//

import Foundation
enum Methods {

    case GET
    case POST
    case PUT
    case DELETE
    
}

enum ErrorType:Error {
    
    case InternalError
    case ServerError
    case parsingError
    case urlBadFormmated
    
}
