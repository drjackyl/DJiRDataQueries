extension Dictionary {
    mutating func appendElement<T>(_ element: T, key: Key) where Value == Array<T> {
        if self[key] == nil {
            self[key] = [element]
        } else {
            self[key]?.append(element)
        }
    }
    
    mutating func insertElement<T>(_ element: T, key: Key) where Value == Set<T> {
        if self[key] == nil {
            self[key] = [element]
        } else {
            self[key]?.insert(element)
        }
    }
}
