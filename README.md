# DJiRDataQueries

DrJackyl's Swift Package for queries on iRacing-Data provides processing and queries for data of [iRacing](https://www.iracing.com). Its scope is to make the data more usable, but requires Apple's Foundation to be used.

## Supported Data

* Event Result in CSV-format.
* Series Race Results (the list of sessions and subsessions on a series' section).

## Examples

`DJiRDataQueries` is the entry-point to decode data for querying, for example event results, exported as CSV-file:

```swift
do {
    let csvData = try Data(contentsOf: URL(fileURLWithPath: "path/to/exported.csv"))
    let eventResult = try DJiRDataQueries().createEventResultFromCSVData(csvData)
    print("\(eventResult.summary.series) at \(eventResult.summary.track)")
    let driver = eventResult.getDriverOfFastestLap()
    print("Car Classes: \(eventResult.carClasses.map { "\($0.name) (\($0.cars.map { car in car.name }.joined(separator: ",")))" }.joined(separator: ", "))")
    print("Fastest lap: \(driver?.fastestLapTime?.lapTimeString ?? "-") (\(driver?.name ?? "-"))")
    print(eventResult.resultsOfTeams.map { "\($0.finPos): \($0.name) (\($0.car))"}.joined(separator: "\n") )
} catch let error {
    print(error)
}
```

## A Remark on the Unit Tests

A good amount of previous unit tests, which tested processing with real data, were removed, because the "real data" disclosed data of members, like real names and customer-IDs, which would otherwise only be visible to members of the service.

Remaining unit tests cover logic or document resolution of bugs in the models.

## Future

* Queries on all data provided by DJiRData.

## Breaking Changes

### &lt; v0.3

The test-resources (DJiRDataTestResources) for testing decoding of real data have been removed, because they exposed member-data, like real names and customer-IDs, wich are otherwise only visible to members.

Hence, the respective unit-tests have been removed as well. I now set this up locally on my machine, where I run the tests.
