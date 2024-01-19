import Foundation

extension Date {
    func convertDateToTimeAgo() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: self, to: now)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        if let timeAgoString = formatter.string(from: components) {
            return timeAgoString + " ago"
        } else if let daysAgo = calendar.dateComponents([.day], from: self, to: now).day, daysAgo >= 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd, MMM, yyyy"
            return dateFormatter.string(from: self)
        } else {
            return "Just now"
        }
    }
}
