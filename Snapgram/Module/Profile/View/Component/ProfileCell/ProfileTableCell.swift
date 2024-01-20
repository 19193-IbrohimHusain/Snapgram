import UIKit

protocol ProfileTableCellDelegate {
    func editProfile()
    func shareProfile()
    func discover()
}

class ProfileTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var followersStack: UIStackView!
    @IBOutlet weak var followingStack: UIStackView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var shareProfileBtn: UIButton!
    @IBOutlet weak var discoverBtn: UIButton!
    
    internal var delegate: ProfileTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        profileImg.layer.cornerRadius = 50.0
        configureBtn(editProfileBtn)
        configureBtn(shareProfileBtn)
        configureBtn(discoverBtn)
    }
    
    internal func configure(with user: User) {
        username.text = user.username
        bio.text = user.email
        address.text = user.userid
    }
    
    internal func configureUserPost(count: Int) {
        postCount.text = "\(count)"
    }
    
    private func configureBtn(_ button: UIButton) {
        button.setAnimateBounce()
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
    }
    
    @IBAction private func onEditProfileBtnTap() {
        self.delegate?.editProfile()
    }
    
    @IBAction private func onShareProfileBtnTap() {
        self.delegate?.shareProfile()
    }
    
    @IBAction private func onDiscoverBtnTap() {
        self.delegate?.discover()
    }
}
