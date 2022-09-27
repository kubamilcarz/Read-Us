//
//  ReadingStatus.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import Foundation

@objc enum ReadingStatus: Int64 {
    case notStarted = 0
    case reading = 1
    case finished = 2
    case unfinished = 3

//    public typealias RawValue = String
//
//    public var rawValue: RawValue {
//        switch self {
//        case .notStarted: return "NOTSTARTED"
//        case .reading: return "READING"
//        case .finished: return "FINISHED"
//        case .unfinished: return "UNFINISHED"
//        }
//    }
//
//    public init?(rawValue: RawValue) {
//        switch rawValue {
//            case "NOTSTARTED":
//                self = .notStarted
//            case "READING":
//                self = .reading
//            case "FINISHED":
//                self = .finished
//            case "UNFINISHED":
//                self = .unfinished
//            default:
//                return nil
//        }
//    }
}
