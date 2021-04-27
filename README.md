# DJiRDataQueries

DrJackyl's Swift Package for queries on iRacing-Data provides processing and queries for data of [iRacing](https://www.iracing.com). Its scope is to make the data more usable.

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

The unit-tests are based on "real data", rather than constructed data, to identify specialties in the raw data retrieved from iRacing itself.

## Future

* Queries on all data provided by DJiRData.
