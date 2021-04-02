import Foundation

extension TimeInterval {
    
    /**
     Initializes a TimeIneral with a time-strings of the format "-m:ss.SSS"
     
     ## Format
     
     iRacing uses a human readable format for times in the CSV-exports. Its format is "-M.SS.fff" in some variations:
     
     - Positive time-intervals have no prefix.
     - Negative time-intervals have a "-" as a prefix.
     - Time-intervals smaller than 1 minute ommit the component for minutes and do not pad the seconds with zeros.
     */
    init?(iRacingCSVTimeString: String?) {
        guard let iRacingCSVTimeString = iRacingCSVTimeString else { return nil }
        
        if !iRacingCSVTimeString.contains("."),
           let milliseconds = Double(iRacingCSVTimeString) {
            self = milliseconds / 1000
        } else if let timeInterval = TimeInterval(iRacingCSVTimeString) {
            self = timeInterval
        } else {
            let components = iRacingCSVTimeString.split(separator: ":")
            guard components.count == 2,
                  let minutes = Double(components[0]),
                  let seconds = TimeInterval(components[1]),
                  seconds >= 0 && seconds < 60
            else { return nil }
            
            if minutes >= 0 {
                self = minutes * 60 + seconds
            } else {
                self = minutes * 60 - seconds
            }
        }
    }
    
    var lapTimeString: String {
        if self > 60 {
            let minutes = Int(self) / 60
            let remainder = self - TimeInterval(minutes * 60)
            return "\(minutes):\(String(format: "%06.3f", remainder))"
        } else if self < -60 {
            let minutes = Int(self) / 60
            let remainder = -1 * (self - TimeInterval(minutes * 60))
            return "\(minutes):\(String(format: "%06.3f", remainder))"
        } else if self >= 10 || self <= -10 {
            return String(format: "%06.3f", self)
        } else {
            return String(format: "%05.3f", self)
        }
    }
    
}
