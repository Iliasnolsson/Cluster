import XCTest
@testable import Cluster

final class ClusterTests: XCTestCase {
    
    func testEquality() {
        let a = Cluster(primary: 1, secondaries: [2, 3])
        let b = Cluster(primary: 1, secondaries: [2, 3])
        let c = Cluster(primary: 1, secondaries: [3, 2])
        let d = Cluster(primary: 1, secondaries: [])
        
        XCTAssertEqual(a, b) // equal clusters
        XCTAssertEqual(b, a) // equality is symmetric
        XCTAssertNotEqual(a, c) // order of secondaries matters
        XCTAssertNotEqual(a, d) // different number of secondaries
    }
    
    func testClusterArray() throws {
        let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
        XCTAssertEqual(cluster.array(), ["A", "B", "C"])
    }
    
    func testFlatArray() throws {
        let cluster = Cluster(primary: [1, 2, 3], secondaries: [[4, 5], [6, 7, 8]])
        XCTAssertEqual(cluster.flatArray(), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    func testCodableCluster() throws {
        let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
        let codableCluster = cluster.codable()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(codableCluster)
        let decoder = JSONDecoder()
        let decodedCluster = try decoder.decode(CodableCluster<String>.self, from: data)
        
        XCTAssertEqual(decodedCluster.primary, "A")
        XCTAssertEqual(decodedCluster.secondaries, ["B", "C"])
    }
    
    func testMapWithOtherSelection() throws {
        let cluster1 = Cluster(primary: 2, secondaries: [4, 6, 8])
        let cluster2 = Cluster(primary: 1, secondaries: [3, 5, 7])
        
        let result = cluster1.map(with: cluster2, { $0 * $1 })
        XCTAssertEqual(result.primary, 2)
        XCTAssertEqual(result.secondaries, [12, 30, 56])
    }
    
    func testMap() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["World"])
        let result = cluster.map({ $0.count })
        XCTAssertEqual(result.primary, 5)
        XCTAssertEqual(result.secondaries, [5])
    }
    
    func testCompactMap() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
        let result = cluster.compactMap({ $0.isEmpty ? nil : $0.count })
        XCTAssertEqual(result?.primary, 5)
        XCTAssertEqual(result?.secondaries, [5])
    }
    
    func testAllSatisfy() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["Worlds"])
        XCTAssertFalse(cluster.allSatisfy({ $0.count > 5 }))
    }
    
    func testAllEqualsSameValue() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["Hello", "Boats"])
        XCTAssertTrue(cluster.allEqualsSameValue({ $0.count }))
        XCTAssertFalse(cluster.allEqualsSameValue({ $0 }))
    }
    
    func testMin() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
        let result = cluster.min(by: { $0.count < $1.count })
        XCTAssertEqual(result, "")
    }
    
    func testMax() throws {
        let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
        let result = cluster.max(by: { $0.count < $1.count })
        XCTAssertEqual(result, "Hello")
    }
}
