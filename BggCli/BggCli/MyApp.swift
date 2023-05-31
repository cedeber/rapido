import ArgumentParser
import Foundation
import SWXMLHash

struct BoardGame {
    let id: Int
    let name: String
    let year: Int?
    let min_players: Int?
    let max_players: Int?
    let playtime: Int? // minutes
}

@main
struct Bgg: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Simple program to list all board games from a BoardGameGeek user.", version: "0.1.0")

    @Argument(help: "BoardGameGeek Username")
    var user: String

    @Option(name: .shortAndLong, help: "Filter by title with a RegExp")
    var filter: String?

    @Option(name: .shortAndLong, help: "How long you want to play, in minutes. (+/- 10 minutes)")
    var time: Int?

    @Option(name: .shortAndLong, help: "How many players")
    var players: Int?

    mutating func run() async throws {
        try? await fetchCollection(username: &user)
    }
}

func fetchCollection(username: inout String) async throws {
    let url = URL(string: "https://boardgamegeek.com/xmlapi/collection/\(username)")
    let (data, _) = try await URLSession.shared.data(from: url!)

    let xml = XMLHash.parse(data)

    if let errors = try? xml.byKey("errors") {
        let message = errors["error"]["message"].element?.text
        print("Error:", message!)
        return
    }

    if let message = try? xml.byKey("message").element?.text {
        print("Error:", message)
        return
    }

    for item in xml["items"]["item"].all {
        if let game = try? item.withAttribute("subtype", "boardgame") {
            let title = game["name"].element?.text
            print(title ?? "Unknown Title")
        }
    }
}
