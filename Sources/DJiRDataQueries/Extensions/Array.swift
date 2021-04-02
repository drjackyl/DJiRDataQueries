extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        Set<Element>(self)
    }
    
    func distinct() -> [Element] {
        Array<Element>(toSet())
    }
}
