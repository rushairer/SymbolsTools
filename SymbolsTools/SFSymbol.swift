//
//  SFSymbol.swift
//  SymbolsTools
//
//  Created by Abenx on 2023/1/13.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct SFSymbol {
    
    static let shared = SFSymbol()
    
    struct JsonStruct: Codable {
        var id: Int
        var name: String
        var title: String
        var value: String
    }
    
    static var namesOfSFSymbols: [String]? = {
        if let path = Bundle(identifier: "com.apple.CoreGlyphs")?.path(forResource: "name_availability", ofType: "plist"),
           let dataDictionary = NSDictionary(contentsOfFile: path) {
            if let symbols = dataDictionary["symbols"] as? NSDictionary {
                return symbols.allKeys as? [String]
            }
        }
        return nil
    }()
    
    
    static var orderOfSFSymbols: [String]? = {
        if let path = Bundle(identifier: "com.apple.CoreGlyphs")?.path(forResource: "symbol_order", ofType: "plist"),
           let symbols = NSArray(contentsOfFile: path) {
            return Array(symbols) as? [String]
        }
        return nil
    }()
    
    func jsonData() throws -> Data? {
        var symbols: [JsonStruct] = []
        if let names = SFSymbol.orderOfSFSymbols {
            names.indices.forEach({ index in
                let symbol: JsonStruct = JsonStruct(
                    id: index + 1,
                    name: names[index],
                    title: names[index],
                    value: "\(Image(systemName: names[index]))")
                
                symbols.append(symbol)
            })
        }
        
        let encoder = JSONEncoder()
        return try encoder.encode(symbols)
    }
    
    func plistData() throws -> Data? {
        if let names = SFSymbol.orderOfSFSymbols {
            let newData = NSDictionary(dictionary: ["symbols" : names])
            return try PropertyListSerialization.data(fromPropertyList: newData, format: .xml, options: 0)
        } else {
            return nil
        }
    }
}


class SFSymbolNamesDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    private var fileData: Data?
    
    required init(configuration: ReadConfiguration) throws {
        
    }
    
    init(jsonData: Data) {
        self.fileData = jsonData
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let fw = FileWrapper(regularFileWithContents: self.fileData!)
        return fw
    }
}

class SFSymbolNamesPlistDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.propertyList] }
    
    private var fileData: Data?
    
    required init(configuration: ReadConfiguration) throws {
        
    }
    
    init(data: Data) {
        self.fileData = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let fw = FileWrapper(regularFileWithContents: self.fileData!)
        return fw
    }
}
