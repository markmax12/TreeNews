//
//  File.swift
//  
//
//  Created by Maxim Ivanov on 04.05.2023.
//

import Foundation

extension TreeNews {
    public static func exit(withError error: Error) -> Never {
        switch error {
        case let e as RunTimeError:
            print(e.description)
        default:
            print(error.localizedDescription)
        }
        
        Application.exit(Application.exitCodeFailure)
    }
}

enum Application {
}

extension Application {
    static var exitCodeFailure: Int32 {
      EXIT_FAILURE
    }
    
    static func exit(_ code: Int32) -> Never {
#if canImport(Glibc)
        Glibc.exit(code)
#elseif canImport(Darwin)
        Darwin.exit(code)
#elseif canImport(CRT)
        ucrt._exit(code)
#elseif canImport(WASILibc)
        WASILibc.exit(code)
#endif
    }
}
