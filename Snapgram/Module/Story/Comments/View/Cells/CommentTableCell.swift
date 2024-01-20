import UIKit

protocol CommentTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
    func reply()
}
class CommentTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeStackView: UIStackView!
    
    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        profileImg.layer.cornerRadius = 12
        replyTableView.delegate = self
        replyTableView.dataSource = self
        replyTableView.registerCellWithNib(ReplyCommentTableCell.self)
        heightTableView.constant = 20
    }
    
    func configure() {
        username.text = ""
        comment.text = ""
        likeCount.text = ""
    }
}

extension CommentTableCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = replyTableView.dequeueReusableCell(forIndexPath: indexPath) as ReplyCommentTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooterViewIdentifier") as? CustomFooterView
        ?? CustomFooterView(reuseIdentifier: "CustomFooterViewIdentifier")
        
        footer.configure(with: "View 20 replies")
        
        footer.footerTapped = {
            self.heightTableView.constant = tableView.contentSize.height
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
}
