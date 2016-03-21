//
//  Bootstrapping.swift
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 02. 06..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import Foundation

enum BootstrappingError: ErrorType {
    case ExpectedComponentNotFound(String)
}

protocol Bootstrapping {

    func bootstrap(bootstrapped: Bootstrapped) throws
}

struct Bootstrapped {

    private let bootstrappedComponents: [Bootstrapping]

    init() {
        self.init(components: [])
    }

    init(components: [Bootstrapping]) {
        self.bootstrappedComponents = components
    }

    func bootstrap(component: Bootstrapping) throws -> Bootstrapped {
        try component.bootstrap(self)
        return Bootstrapped(components: bootstrappedComponents + component)
    }

    func component<T: Bootstrapping>(componentType: T.Type) throws -> T {
        guard let found = bootstrappedComponents.filter({ $0 is T }).first as? T else {
            throw BootstrappingError.ExpectedComponentNotFound("\(T.self)")
        }

        return found
    }
}

struct Bootstrapper {

    static func bootstrap(components: [Bootstrapping]) throws -> Bootstrapped {
        return try components.reduce(Bootstrapped()) { bootstrapped, next in
            return try bootstrapped.bootstrap(next)
        }
    }
}

private func +(left: [Bootstrapping], right: Bootstrapping) -> [Bootstrapping] {
    var result = Array<Bootstrapping>(left)
    result.append(right)

    return result
}
