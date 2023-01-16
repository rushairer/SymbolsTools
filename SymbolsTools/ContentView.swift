//
//  ContentView.swift
//  SymbolsTools
//
//  Created by Abenx on 2023/1/13.
//

import SwiftUI

struct ContentView: View {
    @State var showsExportFile: Bool = false
    @State var showsExportPlistFile: Bool = false
    
    var document: SFSymbolNamesDocument {
        do {
            if let data = try SFSymbol.shared.jsonData() {
                return SFSymbolNamesDocument(jsonData: data)
            }
            return SFSymbolNamesDocument(jsonData: Data())
        } catch {
            return SFSymbolNamesDocument(jsonData: Data())
        }
    }
    
    var plistDocument: SFSymbolNamesPlistDocument {
        do {
            if let data = try SFSymbol.shared.plistData() {
                return SFSymbolNamesPlistDocument(data: data)
            }
            return SFSymbolNamesPlistDocument(data: Data())
        } catch {
            return SFSymbolNamesPlistDocument(data: Data())
        }
    }
    //
    //    var diffNames: [String]?  {
    //        if let names = SFSymbol.namesOfSFSymbols, let orders = SFSymbol.orderOfSFSymbols {
    //            var newNames = names
    //            orders.forEach { order in
    //                if let hasIndex = newNames.firstIndex(of: order) {
    //                    newNames.remove(at: hasIndex)
    //                }
    //            }
    //            return newNames
    //        } else {
    //            return nil
    //        }
    //    }
    //
    var body: some View {
        VStack {
            HStack {
                Button {
                    showsExportFile = true
                } label: {
                    Text("Export JSON File")
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button {
                    showsExportPlistFile = true
                } label: {
                    Text("Export Plist File")
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            
            HStack {
                if let names = SFSymbol.orderOfSFSymbols {
                    ScrollView{
                        HStack {
                            Text("\(names.count)")
                            Text("\(SFSymbol.namesOfSFSymbols!.count)")
                            Text("\(SFSymbol.orderOfSFSymbols!.count)")
                        }
                        LazyVStack {
                            ForEach(names, id: \.self) { name in
                                Text("\(name) \(Image(systemName: name))")
                            }
                        }
                    }
                }
            }
        }
        .fileExporter(isPresented: $showsExportFile,
                      document: document,
                      contentType: .json,
                      defaultFilename: "SFSymbolNames") { result in
            print(result)
        }
        .fileExporter(isPresented: $showsExportPlistFile,
                      document: plistDocument,
                      contentType: .propertyList,
                      defaultFilename: "SFSymbolNames") { result in
            print(result)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
