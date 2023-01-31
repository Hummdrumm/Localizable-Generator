import Foundation
import ANSITerminal
import ArgumentParser
import Files
import SwiftFigletKit

enum Platform: StringLiteralType, ExpressibleByArgument {
    case ios
    case android
}

@main
struct GenerateLocalizables: ParsableCommand {
    @Argument(help: "Enter the PATH where the Files to be created")
    var destinationPath: String
    @Argument(help: "Enter the URL where the document is hosted")
    var url: String
    @Argument(help: "Enter the Platform ios/android")
    var platform: Platform

    func run() throws {

        guard let url = URL(string: url + "/export?format=tsv"),
              self.url.contains("https://") else {
            print("❌ Need a valid URL for the document, ".red + "'\( url )' is not a valid URL format".asMagenta)
            return
        }
        print("🗂 Destination Folder \(Folder.current.path)/\(destinationPath)")
        print("🔗 Google Sheets URL \(url.absoluteString)")

        CSVDownloader(csvURL: url, destination: destinationPath, platform: platform).downloadCSV()

        RunLoop.main.run()
    }
}

