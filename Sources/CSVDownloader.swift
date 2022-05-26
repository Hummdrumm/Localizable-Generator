//
//  CSVDownloader.swift
//  GenerateLocalizables
//
//  Created by Jose Escabias on 24/10/21.
//  Copyright © 2021 Jose Escabias. All rights reserved.
//

import Foundation
import Files

class CSVDownloader {
    let csvURL: URL
    let destination: String
    var didFailed: Bool = false

    public init(csvURL: URL, destination: String) {
        self.csvURL = csvURL
        self.destination = destination
    }

    func downloadCSV() {

        print("⬇️ Downloading Localizable file ...".blue)
        var end = false

        let task = URLSession.shared.dataTask(with: csvURL) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let data = data, let csvString = String(data: data, encoding: .utf8) {
                self.parseCSVString(csvString, destination: self.destination)
            }

            end = true
        };

        task.resume() // launch task

            // show ASCII animation while downloading
        let animation = ["|", "/", "-", "\\"]
        var animationIndex = 0
        while (!end) {

            print("\(animation[animationIndex])\r", separator: "", terminator: "")

            if animationIndex < animation.count - 1 {
                animationIndex = animationIndex + 1
            } else {
                animationIndex = 0
            }
        }

        if didFailed {
            print("❌ ERROR CREATING LOCALIZABLE ❌".red)
            exit(EXIT_FAILURE)
        } else {
            print("✅ LOCALIZABLES FILES DID UPDATE SUCCESSFULLY".lightGreen)
            exit(EXIT_SUCCESS)
        }

        print("\r  ")
    }

    private func parseCSVString(_ csvString: String, destination: String) {

        var localizables = [Localizable]()
        var rows = csvString.components(separatedBy: "\n")

        guard let firstRow = rows.first else {
            return
        }

        let languages = firstRow.components(separatedBy: "\t")
            .map { $0.replacingOccurrences(of: "\r", with: "")}
            .filter { !$0.contains("Identifier")}


        guard languages.count != 0 else {
            print("You need to add at least one language colum on the document ❌".red)
            didFailed.toggle()
            exit(EXIT_FAILURE)
        }

        rows.removeFirst()

        var loopCount = 1
        var valueIndex = 2
        while loopCount <= languages.count {
            rows.forEach { row in
                let colums = row.components(separatedBy: "\t")

                let key = colums[0]
                let value = colums[valueIndex].replacingOccurrences(of: "\r", with: "")
                localizables.append(.init(key: key, value: value))

            }

            valueIndex += 1
                // save in document
            do {
                try LocalizableGenerator.createFile(for: languages[loopCount - 1], with: localizables, destination: destination)
            } catch {
                print("❌ ERROR CREATING LOCALIZABLE ❌".red)
                didFailed.toggle()
                exit(EXIT_FAILURE)
            }

                // turn empty the localizables array
            localizables.removeAll()

            loopCount += 1
        }
    }
}
