import DependenciesGraphCore

final class DumpPackageMock: DumpPackage {
    
   // MARK: - dumpPackage

    var dumpPackagePackageRootDirectoryPathThrowableError: Error?
    var dumpPackagePackageRootDirectoryPathCallsCount = 0
    var dumpPackagePackageRootDirectoryPathCalled: Bool {
        dumpPackagePackageRootDirectoryPathCallsCount > 0
    }
    var dumpPackagePackageRootDirectoryPathReceivedPackageRootDirectoryPath: String?
    var dumpPackagePackageRootDirectoryPathReceivedInvocations: [String?] = []
    var dumpPackagePackageRootDirectoryPathReturnValue: String!
    var dumpPackagePackageRootDirectoryPathClosure: ((String?) throws -> String)?

    func dumpPackage(packageRootDirectoryPath: String?) throws -> String {
        if let error = dumpPackagePackageRootDirectoryPathThrowableError {
            throw error
        }
        dumpPackagePackageRootDirectoryPathCallsCount += 1
        dumpPackagePackageRootDirectoryPathReceivedPackageRootDirectoryPath = packageRootDirectoryPath
        dumpPackagePackageRootDirectoryPathReceivedInvocations.append(packageRootDirectoryPath)
        return try dumpPackagePackageRootDirectoryPathClosure.map({ try $0(packageRootDirectoryPath) }) ?? dumpPackagePackageRootDirectoryPathReturnValue
    }
}
