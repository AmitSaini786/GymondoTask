//
//  Exercises.swift
//  AssignmentGymondo
//
//  Created by Amit on 02/05/22.
//

import Foundation


// MARK: - Welcome
struct Exercises: Codable {
    let count: Int
    let next: String
    let previous: JSONNull?
    let results: [ExercisesData]
}

// MARK: - Result
struct ExercisesData: Codable {
    let id: Int
    let uuid, name: String
    let exerciseBase: Int
    let resultDescription, creationDate: String
    let category: Int
    let muscles, musclesSecondary, equipment: [Int]
    let language, license: Int
    let licenseAuthor: String
    let variations: [Int]

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case resultDescription = "description"
        case creationDate = "creation_date"
        case category, muscles
        case musclesSecondary = "muscles_secondary"
        case equipment, language, license
        case licenseAuthor = "license_author"
        case variations
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
    
}
