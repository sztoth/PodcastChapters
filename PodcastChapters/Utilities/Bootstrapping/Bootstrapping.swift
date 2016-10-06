//
//  Bootstrapping.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

enum BootstrappingError: Error {
    case expectedComponentNotFound(String)
}

protocol Bootstrapping {
    func bootstrap(_ bootstrapped: Bootstrapped) throws
}

struct Bootstrapped {
    fileprivate let bootstrappedComponents: [Bootstrapping]

    init() {
        self.init(components: [])
    }

    init(components: [Bootstrapping]) {
        self.bootstrappedComponents = components
    }
}

extension Bootstrapped {
    func bootstrap(_ component: Bootstrapping) throws -> Bootstrapped {
        try component.bootstrap(self)
        return Bootstrapped(components: bootstrappedComponents + component)
    }

    func component<T: Bootstrapping>(_ componentType: T.Type) throws -> T {
        guard let found = bootstrappedComponents.filter({ $0 is T }).first as? T else {
            throw BootstrappingError.expectedComponentNotFound("\(T.self)")
        }

        return found
    }
}

struct Bootstrapper {
    static func bootstrap(_ components: [Bootstrapping]) throws -> Bootstrapped {
        return try components.reduce(Bootstrapped()) { bootstrapped, next in
            return try bootstrapped.bootstrap(next)
        }
    }
}

fileprivate func +(left: [Bootstrapping], right: Bootstrapping) -> [Bootstrapping] {
    return left + [right]
}
