import UIKit

class BaseCell: UICollectionViewCell {
}

class ForecastCell: BaseCell {
    @IBOutlet weak var icon: UIImageView?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var stateLabel: UILabel?
    @IBOutlet weak var windDirIcon: UIImageView?
    
    func setWindDirection(to degrees: Double) {
        windDirIcon?.transform = CGAffineTransform(rotationAngle: degrees * .pi / 180)
    }
}

class TodayForecastCell: ForecastCell {
    @IBOutlet weak var maxMinTemp: UILabel?
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var windSpeed: UILabel?
}

class UpcomingForecastCell: ForecastCell {
    @IBOutlet weak var dayLabel: UILabel?
}

class ForecastSourceCell: BaseCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var safariIcon: UIImageView?
}

class WeatherHeader: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel?
    func setTitle(to text: String?) {
        titleLabel?.text = text?.localizedUppercase
    }
}
