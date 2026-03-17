import Foundation

extension Bundle {
    func data(
        forResource name: String,
        withExtension ext: String,
        options: Data.ReadingOptions = []
    ) throws -> Data {
        guard let url = url(forResource: name, withExtension: ext) else {
            throw NSError(domain: bundleIdentifier ?? "", code: NSFileReadNoSuchFileError)
        }

        return try Data(contentsOf: url)
    }
}

extension Bundle {
    public func json<T: Decodable>(
        _ type: T.Type,
        forResource name: String,
        withExtension ext: String = "json",
        decodable: JSONDecoder = .init()
    ) throws -> T {
        let data = try data(forResource: name, withExtension: ext, options: .mappedIfSafe)
        return try decodable.decode(
            type,
            from: data
        )
    }
}
