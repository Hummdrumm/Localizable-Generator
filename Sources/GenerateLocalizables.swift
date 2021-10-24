import Foundation
import ANSITerminal
import ArgumentParser
import Files
import SwiftFigletKit

@main
struct GenerateLocalizables: ParsableCommand {
    @Argument(help: "Enter the URL where the document is hosted")
    var url: String
    
    func run() throws {
        
        guard let url = URL(string: url + "/export?format=csv"),
              self.url.contains("https://") else {
                  print("❌ Need a valid URL for the document, ".red + "'\( url )' is not a valid URL format".asMagenta)
            return
        }
        
        CSVDownloader(csvURL: url).downloadCSV()
    }
}

