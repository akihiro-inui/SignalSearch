
import UIKit

protocol MapMarkerDelegate: AnyObject {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var signalLevelLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
