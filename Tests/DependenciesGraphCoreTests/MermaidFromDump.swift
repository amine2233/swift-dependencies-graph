@testable import DependenciesGraphCore
import Testing
import Foundation

struct MermaidFromDumpTests {
    
    @Test func createMermaid() throws {
        let dump = try Bundle.module.data(forResource: "dump_package", withExtension: "json")
        let dumpPackage = DumpPackageMock()
        dumpPackage.dumpPackagePackageRootDirectoryPathReturnValue = String(data: dump, encoding: .utf8)
        
        let sut = DependenciesReader(
            packageRootDirectoryPath: "",
            decoder: JSONDecoder(),
            dumpPackage: dumpPackage
        )
        let modules = try sut.readDependencies(isIncludeProduct: false)
        let result = MermaidCreator.create(from: modules, stripTransitive: false)
        let expected = """
        ```mermaid
        graph TD;
            ReduxKitUI-->ReduxKit;
            ReduxKitExtensions-->ReduxKit;
            ExampleApp-->ReduxKit;
        ```
        """

        #expect(result == expected)
    }
    
    @Test func createMermaidWithIncludedProduct() throws {
        let dump = try Bundle.module.data(forResource: "dump_package", withExtension: "json")
        let dumpPackage = DumpPackageMock()
        dumpPackage.dumpPackagePackageRootDirectoryPathReturnValue = String(data: dump, encoding: .utf8)
        
        let sut = DependenciesReader(
            packageRootDirectoryPath: "",
            decoder: JSONDecoder(),
            dumpPackage: dumpPackage
        )
        let modules = try sut.readDependencies(isIncludeProduct: true)
        let result = MermaidCreator.create(from: modules, stripTransitive: true)
        let expected = """
        ```mermaid
        graph TD;
            ReduxKitUI-->ReduxKit;
            ReduxKitExtensions-->Collections;
            ReduxKitExtensions-->ReduxKit;
            ExampleApp-->ReduxKit;
        ```
        """

        #expect(result == expected)
    }
}
