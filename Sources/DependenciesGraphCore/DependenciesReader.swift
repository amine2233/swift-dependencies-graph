import Foundation

public protocol DumpPackage {
    func dumpPackage(
        packageRootDirectoryPath: String?
    ) throws -> String
}

struct DumpPackageDefault: DumpPackage {
    func dumpPackage(
        packageRootDirectoryPath: String? = nil
    ) throws -> String {
        try Command.run(
            launchPath: "/usr/bin/env",
            currentDirectoryPath: packageRootDirectoryPath,
            arguments: ["swift", "package", "dump-package"]
        )
    }
}

public struct DependenciesReader {
    private let packageRootDirectoryPath: String
    private let decoder: JSONDecoder
    private let dumpPackage: DumpPackage

    public init(
        packageRootDirectoryPath: String,
        decoder: JSONDecoder = .init(),
        dumpPackage: DumpPackage = MermaidCreator.makeDefaultDumpPackage()
    ) {
        self.packageRootDirectoryPath = packageRootDirectoryPath
        self.decoder = decoder
        self.dumpPackage = dumpPackage
    }

    public func readDependencies(isIncludeProduct: Bool) throws -> [Module] {
        let jsonString = try dumpPackage.dumpPackage(
            packageRootDirectoryPath: packageRootDirectoryPath
        )
        let jsonData = jsonString.data(using: .utf8)!
        return try decoder
            .decode(DumpPackageResponse.self, from: jsonData)
            .toModule(isIncludeProduct: isIncludeProduct)
    }
}

package struct DumpPackageResponse: Decodable {
    let targets: [Target]

    struct Target: Decodable {
        let name: String
        let dependencies: [Dependency]

        struct Dependency: Decodable {
            let target: [String?]?
            let product: [String?]?
        }
    }
}

extension DumpPackageResponse {
    func toModule(isIncludeProduct: Bool) -> [Module] {
        targets.map { target in
            let byNameDependencies = target.dependencies.compactMap { $0.target?.compactMap(\.self).first }
            let productDependencies = target.dependencies.compactMap { $0.product?.compactMap(\.self).first }
            let dependencies = isIncludeProduct ? byNameDependencies + productDependencies : byNameDependencies
            return Module(name: target.name, dependencies: dependencies)
        }
    }
}
