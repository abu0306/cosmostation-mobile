//
//  TokenDetailHeaderCustomCell.swift
//  Cosmostation
//
//  Created by yongjoo on 04/10/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit

class TokenDetailHeaderCustomCell: UITableViewCell {
    
    @IBOutlet weak var tokenImg: UIImageView!
    @IBOutlet weak var tokenSymbol: UILabel!
    @IBOutlet weak var tokenInfoBtn: UIButton!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var availableAmount: UILabel!
    @IBOutlet weak var btnBep3Send: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        availableAmount.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: Font_13_footnote)
    }
    
    var actionSend: (() -> Void)? = nil
    var actionReceive: (() -> Void)? = nil
    var actionTokenInfo: (() -> Void)? = nil
    var actionBep3Send: (() -> Void)? = nil
    
    @IBAction func onClickSend(_ sender: Any) {
        actionSend?()
    }
    
    @IBAction func onClickReceive(_ sender: UIButton) {
        actionReceive?()
    }
    
    
    @IBAction func onClickTokenInfo(_ sender: Any) {
        actionTokenInfo?()
    }
    
    @IBAction func onClickBep3Send(_ sender: UIButton) {
        actionBep3Send?()
    }
    
    override func prepareForReuse() {
        self.tokenImg.image = UIImage(named: "tokenIc")
        self.tokenSymbol.text = "-"
        self.totalAmount.text = "-"
        self.totalValue.text = "-"
        self.tokenName.text = "-"
        self.availableAmount.text = "-"
        super.prepareForReuse()
    }
    
}
