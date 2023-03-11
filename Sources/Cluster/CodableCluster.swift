//
//  CodableSelection.swift
//  secret-project
//
//  Created by Ilias Nikolaidis Olsson on 2022-10-28.
//

import Foundation

public class CodableCluster<T>: Cluster<T>, Codable where T: Codable {
    
    public override init(primary: T, secondaries: [T]) {
        super.init(primary: primary, secondaries: secondaries)
    }
    
    public override init(_ primary: T) {
        super.init(primary)
    }
    
    public override init(_ selection: Cluster<T>) {
        super.init(selection)
    }
    
    private enum CodingKeys: String, CodingKey {
        case primary = "p"
        case secondaries = "s"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primary = try container.decode(T.self, forKey: .primary)
        let secondaries = try container.decode([T].self, forKey: .secondaries)
        super.init(primary: primary, secondaries: secondaries)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(primary, forKey: .primary)
        try container.encode(secondaries, forKey: .secondaries)
    }
    
    public func unwrapp() -> Cluster<T> {
        return .init(self)
    }
    
}
