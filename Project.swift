import ProjectDescription 

let target = Target(name: "GenerateLocalizables",
                    platform: .macOS,
                    product: .commandLineTool,
                    bundleId: "com.jem.GenerateLocalizables",
                    infoPlist: .default,
                    sources: [
                        "Sources/**"
                    ],
                    dependencies: [
                        .package(product: "ANSITerminal"),
                        .package(product: "ArgumentParser"),
                        .package(product: "SwiftFigletKit"),
                        .package(product: "Files")
                    ]
)

let scheme = Scheme(name: "GenerateLocalizables", shared: true, buildAction: .buildAction(targets: ["GenerateLocalizables"]), runAction: .runAction(configuration: .debug, executable: "GenerateLocalizables"))

let prj = Project(name: "GenerateLocalizables",
                  organizationName: "Jose Escabias",
                  packages: [
                    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
                    .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
                    .package(url: "https://github.com/pakLebah/ANSITerminal", from: "0.0.3"),
                    .package(url: "https://github.com/dfreniche/SwiftFiglet", .upToNextMajor(from: "0.2.1"))
                  ],
                  targets: [
                    target
                  ],
                  schemes: [scheme]

)
