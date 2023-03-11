# Cluster

`Cluster` is a Swift library that provides a type for grouping an element and its associated values in an efficient and flexible way. The primary element of a cluster is stored separately from its associated secondary elements, making it easy to access the primary value without iterating through the entire cluster.

Installation
------------

### Swift Package Manager

To install `Cluster` using the Swift Package Manager, add the following line to your `Package.swift` file:


```swift
dependencies: [
    .package(url: "https://github.com/Iliasnolsson/Cluster", from: "1.0.0"..<"2.0.0")
]
```

### Manually

Alternatively, you can manually add the `Cluster.swift` file to your project.

Usage
-----

Here are some examples of how to use `Cluster`.

### Initializing a Cluster

To create a cluster, you can use one of the provided initializers. For example, to create a cluster with a primary element and no secondary elements:


```swift
let cluster = Cluster("A")
```

To create a cluster with a primary element and an array of secondary elements:


```swift
let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
```

To create a cluster from an array of elements:


```swift
let array = ["A", "B", "C"]
let cluster = Cluster(array: array)
```

### Accessing Elements

To access the primary element of a cluster:


```swift
let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
let primary = cluster.primary // "A"
```

To access the secondary elements of a cluster:


```swift
let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
let secondaries = cluster.secondaries // ["B", "C"]
```

To access all elements of a cluster:


```swift
let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
let array = cluster.array() // ["A", "B", "C"]
```

### Mapping Elements

To map the elements of a cluster using a closure:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World"])
let mapped = cluster.map({ $0.count }) // Cluster<Int>(primary: 5, secondaries: [5])
```

To map the elements of a cluster using another cluster and a closure:


```swift
let cluster1 = Cluster(primary: 2, secondaries: [4, 6, 8])
let cluster2 = Cluster(primary: 1, secondaries: [3, 5, 7])
let mapped = try cluster1.map(with: cluster2, { $0 * $1 }) // Cluster<Int>(primary: 2, secondaries: [12, 30, 56])
```

To compact map the elements of a cluster using a closure:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
let compactMapped = try cluster.compactMap({ $0.isEmpty ? nil : $0.count }) // Cluster<Int>(primary: 5, secondaries: [5])
```


### Testing Elements

To check if all elements of a cluster satisfy a given condition:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World"])
let allSatisfy = cluster.allSatisfy({ $0 is String }) // true
```

To check if all secondary elements of a cluster have the same value as the primary element for a given property:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["Hello", "Hello"])
let allEquals
```

> You stopped typing at the title "Testing Elements" in the readme. Can you continue

Sure, sorry about that! Here's the complete `Testing Elements` section:

### Testing Elements

To check if all elements of a cluster satisfy a given condition:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World"])
let allSatisfy = cluster.allSatisfy({ $0 is String }) // true
```

To check if all secondary elements of a cluster have the same value as the primary element for a given property:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["Hello", "Hello"])
let allEquals = cluster.allEqualsSameValue({ $0.count }) // true
```

### Finding Elements

To find the minimum element of a cluster:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
let minElement = try cluster.min(by: { $0.count < $1.count }) // ""
```

To find the maximum element of a cluster:


```swift
let cluster = Cluster(primary: "Hello", secondaries: ["World", ""])
let maxElement = try cluster.max(by: { $0.count < $1.count }) // "Hello"
```

### Codable Conformance

`Cluster` also conforms to the `Codable` protocol, making it easy to encode and decode instances of the type using `JSONEncoder` and `JSONDecoder`. For example:


```swift
let cluster = Cluster(primary: "A", secondaries: ["B", "C"])
let encoder = JSONEncoder()
let data = try encoder.encode(cluster)

let decoder = JSONDecoder()
let decodedCluster = try decoder.decode(Cluster<String>.self, from: data)
```

Requirements
------------

*   Swift 5.6+

Contributing
------------

Contributions to `Cluster` are welcome and encouraged! If you have an idea for a new feature or improvement, please open an issue or pull request.

License
-------

`Cluster` is available under the MIT license. See the LICENSE file for more info.
