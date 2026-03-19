import DependenciesGraphCore

enum DumpPackageMockError: Error {
    case missingReturnValue
}

final class DumpPackageMock: DumpPackage {
    
   // MARK: - dumpPackage

    var dumpPackagePackageRootDirectoryPathThrowableError: Error?
    var dumpPackagePackageRootDirectoryPathCallsCount = 0
    var dumpPackagePackageRootDirectoryPathCalled: Bool {
        dumpPackagePackageRootDirectoryPathCallsCount > 0
    }
    var dumpPackagePackageRootDirectoryPathReceivedPackageRootDirectoryPath: String?
    var dumpPackagePackageRootDirectoryPathReceivedInvocations: [String?] = []
    var dumpPackagePackageRootDirectoryPathReturnValue: String?
    var dumpPackagePackageRootDirectoryPathClosure: ((String?) throws -> String)?

    func dumpPackage(packageRootDirectoryPath: String?) throws -> String {
        if let error = dumpPackagePackageRootDirectoryPathThrowableError {
            throw error
        }
        dumpPackagePackageRootDirectoryPathCallsCount += 1
        dumpPackagePackageRootDirectoryPathReceivedPackageRootDirectoryPath = packageRootDirectoryPath
        dumpPackagePackageRootDirectoryPathReceivedInvocations.append(packageRootDirectoryPath)

        if let closure = dumpPackagePackageRootDirectoryPathClosure {
            return try closure(packageRootDirectoryPath)
        }
        if let returnValue = dumpPackagePackageRootDirectoryPathReturnValue {
            return returnValue
        }
        throw DumpPackageMockError.missingReturnValue
    }
}
