//
//  NetworkManager.swift
//  RickDisk
//
//  Created by Рахим Габибли on 03.07.2024.
//

import Foundation
import Disk

struct ReturnedClass: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let image: String
    let species: String
    let gender: String
    let status: String
    let origin: Location
}

struct Location: Codable {
    let name: String
}

class NetworkManager {

    let urlString = "https://rickandmortyapi.com/api/character"

    func getCharacters(complition: @escaping ([Character]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            guard let data else {
                print("No data")
                return
            }

            do {
                let characters = try JSONDecoder().decode(ReturnedClass.self, from: data).results
                print("Good")

                    complition(characters)

            } catch {
                print("Error", error.localizedDescription)
            }
        }.resume()

    }

    func saveCharactersToDisk(_ characters: [Character]) {
        do {
            try Disk.save(characters, to: .documents, as: "characters.json")
            print("Characters saved to disk")
        } catch {
            print("Error saving characters: ", error.localizedDescription)
        }
    }

    func getCharactersFromDisk() -> [Character]? {
        do {
            let characters = try Disk.retrieve("characters.json", from: .documents, as: [Character].self)
            print("Characters get from disk")
            return characters
        } catch {
            print("Error get characters: ", error.localizedDescription)
            return nil
        }

    }

}
