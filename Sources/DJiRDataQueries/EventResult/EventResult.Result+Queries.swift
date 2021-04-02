extension EventResult.Result {
    public var isTeamEntry: Bool { customerID < 0 }
    public var isDriverEntry: Bool { customerID > 0 }
}

extension Array where Element == EventResult.Result {
    
    func getCarClassesInSession() -> Set<EventResult.CarClass> {
        var carClasses: Set<EventResult.CarClass> = []
        
        let carClassIDs = map { $0.carClassID }.distinct()
        carClassIDs.forEach { carClassID in
            var cars: [EventResult.Car] = []
            var carClassName: String?
            let carIDsInClass = self.filter { $0.carClassID == carClassID }.map { $0.carID }.distinct()
            carIDsInClass.forEach { carID in
                guard let resultWithCar = self.first(where: { $0.carID == carID }) else { return }
                if carClassName == nil { carClassName = resultWithCar.carClass }
                let car = EventResult.Car(resultWithCar)
                cars.append(car)
            }
            
            guard cars.count > 0,
                  let name = carClassName
            else { return }
            
            let carClass = EventResult.CarClass(name: name, ID: carClassID, cars: cars.toSet())
            carClasses.insert(carClass)
        }
        return carClasses
    }
    
}
