//
//  StepGenTxViewController.swift
//  Cosmostation
//
//  Created by yongjoo on 08/04/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit
import Alamofire

class StepGenTxViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    fileprivate var currentIndex = 0
    var disableBounce = false
    
    var topVC: TransactionViewController!
    var mType: String?
    
    var mAccount: Account?
    var chainType: ChainType?
    var mBalances = Array<Balance>()
    var mBondingList = Array<Bonding>()
    var mUnbondingList = Array<Unbonding>()
    
    var mRewardList = Array<Reward>()
    var mIrisRewards: IrisRewards?
    var mRewardAddress: String?
    
    var mTargetValidator: Validator?
    var mToDelegateAmount: Coin?
    var mToUndelegateAmount:Coin?
    var mRewardTargetValidators = Array<Validator>()
    
    var mToSendRecipientAddress:String?
    var mToSendAmount = Array<Coin>()
    
    var mToReDelegateAmount: Coin?
    var mToReDelegateValidator: Validator?
    var mToReDelegateValidators = Array<Validator>()
    
    var mCurrentRewardAddress: String?
    var mToChangeRewardAddress: String?
    
    var mReinvestReward: Coin?
    
    var mMemo: String?
    var mFee: Fee?
    
    var mCollateral = Coin.init()
    var mPrincipal = Coin.init()
    var mPayment = Coin.init()
    var mSender: String?
    
    var currentPrice: NSDecimalNumber?
    var liquidationPrice: NSDecimalNumber?
    var riskRate: NSDecimalNumber?
    var beforeLiquidationPrice: NSDecimalNumber?
    var afterLiquidationPrice: NSDecimalNumber?
    var beforeRiskRate: NSDecimalNumber?
    var afterRiskRate: NSDecimalNumber?
    var totalDepositAmount: NSDecimalNumber?
    var totalLoanAmount: NSDecimalNumber?
    
    var mProvision: String?
    var mStakingPool: NSDictionary?
    
    var mIrisStakePool: NSDictionary?
    var mirisRedelegate: Array<NSDictionary>?
    
    var mIrisToken: IrisToken?
    var mBnbToken: BnbToken?
    var mBnbTics = [String : NSMutableDictionary]()
    
    var mProposeId: String?
    var mProposalTitle: String?
    var mProposer: String?
    var mVoteOpinion: String?
    
    var mKavaSendDenom: String?
    var mIovSendDenom: String?
    
    var cDenom: String?
    var pDenom: String?
    var mMarketID: String?
    
    var mHtlcDenom: String?
    var mHtlcToChain: ChainType?
    var mHtlcToAccount: Account?
    var mHtlcSendFee: Fee?
    var mHtlcClaimFee: Fee?
    
    
    var mHtlcRefundSwapId: String?
    var mBnbSwapInfo: BnbSwapInfo?
    var mKavaSwapInfo: KavaSwapInfo?
    var mSwapRemainCap: NSDecimalNumber = NSDecimalNumber.zero
    var mSwapMaxOnce: NSDecimalNumber = NSDecimalNumber.zero
    

    
    lazy var orderedViewControllers: [UIViewController] = {
        if (mType == COSMOS_MSG_TYPE_DELEGATE || mType == IRIS_MSG_TYPE_DELEGATE) {
            return [self.newVc(viewController: "StepDelegateAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepDelegateCheckViewController")]
            
        } else if (mType == COSMOS_MSG_TYPE_UNDELEGATE2 || mType == IRIS_MSG_TYPE_UNDELEGATE) {
            return [self.newVc(viewController: "StepUndelegateAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepUndelegateCheckViewController")]
            
        } else if (mType == COSMOS_MSG_TYPE_TRANSFER2 || mType == IRIS_MSG_TYPE_TRANSFER || mType == BNB_MSG_TYPE_TRANSFER || mType == KAVA_MSG_TYPE_TRANSFER || mType == IOV_MSG_TYPE_TRANSFER || mType == BAND_MSG_TYPE_TRANSFER) {
            return [self.newVc(viewController: "StepSendAddressViewController"),
                    self.newVc(viewController: "StepSendAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepSendCheckViewController")]
            
        } else if (mType == COSMOS_MSG_TYPE_REDELEGATE2 || mType == IRIS_MSG_TYPE_REDELEGATE) {
            return [self.newVc(viewController: "StepRedelegateAmountViewController"),
                    self.newVc(viewController: "StepRedelegateToViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepRedelegateCheckViewController")]
            
        } else if (mType == COSMOS_MSG_TYPE_WITHDRAW_MIDIFY || mType == IRIS_MSG_TYPE_WITHDRAW_MIDIFY) {
            return [self.newVc(viewController: "StepChangeAddressViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepChangeCheckViewController")]
            
        } else if (mType == COSMOS_MULTI_MSG_TYPE_REINVEST) {
            return [self.newVc(viewController: "ReInvestAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "ReInvestCheckViewController")]
            
        } else if (mType == TASK_TYPE_VOTE) {
            return [self.newVc(viewController: "VoteSelectViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "VoteCheckViewController")]
           
        } else if (mType == KAVA_MSG_TYPE_CREATE_CDP) {
            return [self.newVc(viewController: "StepCreateCpdAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepCreateCpdCheckViewController")]
            
        } else if (mType == KAVA_MSG_TYPE_DEPOSIT_CDP) {
            return [self.newVc(viewController: "StepDepositCdpAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepDepositCdpCheckViewController")]
            
        } else if (mType == KAVA_MSG_TYPE_WITHDRAW_CDP) {
            return [self.newVc(viewController: "StepWithdrawCdpAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepWithdrawCdpCheckViewController")]
            
        } else if (mType == KAVA_MSG_TYPE_DRAWDEBT_CDP) {
            return [self.newVc(viewController: "StepDrawDebtCdpAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepDrawDebtCdpCheckViewController")]
            
        } else if (mType == KAVA_MSG_TYPE_REPAYDEBT_CDP) {
            return [self.newVc(viewController: "StepRepayCdpAmountViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepRepayCdpCheckViewController")]
            
        } else if (mType == TASK_TYPE_HTLC_SWAP) {
            return [self.newVc(viewController: "StepHtlcSend0ViewController"),
                    self.newVc(viewController: "StepHtlcSend1ViewController"),
                    self.newVc(viewController: "StepHtlcSend2ViewController"),
                    self.newVc(viewController: "StepHtlcSend3ViewController")]
            
        } else if (mType == TASK_TYPE_HTLC_REFUND) {
            return [self.newVc(viewController: "StepHtlcRefund0ViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepHtlcRefund3ViewController")]
            
        } else if (mType == KAVA_MSG_TYPE_INCENTIVE_REWARD) {
            return [self.newVc(viewController: "StepIncentive0ViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepIncentive3ViewController")]
            
        } else {
            return [self.newVc(viewController: "StepRewardViewController"),
                    self.newVc(viewController: "StepMemoViewController"),
                    self.newVc(viewController: "StepFeeViewController"),
                    self.newVc(viewController: "StepRewardCheckViewController")]
            
        }
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mAccount        = BaseData.instance.selectAccountById(id: BaseData.instance.getRecentAccountId())
        mBalances       = mAccount!.account_balances
        mBondingList    = BaseData.instance.selectBondingById(accountId: mAccount!.account_id)
        mUnbondingList  = BaseData.instance.selectUnbondingById(accountId: mAccount!.account_id)
        chainType       = WUtils.getChainType(mAccount!.account_base_chain)
        
        if (mType == COSMOS_MSG_TYPE_REDELEGATE2) {
            onFetchTopValidatorsInfo()
        } else if (mType == IRIS_MSG_TYPE_REDELEGATE) {
            self.irisValidatorPage = 1;
            self.onFetchIrisValidatorsInfo(irisValidatorPage)
        }
            
        self.dataSource = self
        self.delegate = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.delegate = self
                subView.isScrollEnabled = false
                subView.bouncesZoom = false

            }
        }
        disableBounce = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func newVc(viewController: String) ->UIViewController {
        return UIStoryboard(name: "GenTx", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func onBeforePage() {
        disableBounce = false
        if(currentIndex == 0) {
            self.navigationController?.popViewController(animated: true)
        } else {
            setViewControllers([orderedViewControllers[currentIndex - 1]], direction: .reverse, animated: true, completion: { (finished) -> Void in
                self.currentIndex = self.currentIndex - 1
                let value:[String: Int] = ["step": self.currentIndex ]
                NotificationCenter.default.post(name: Notification.Name("stepChanged"), object: nil, userInfo: value)
                let currentVC = self.orderedViewControllers[self.currentIndex] as! BaseViewController
                currentVC.enableUserInteraction()
                self.disableBounce = true
            })
        }
        
    }
    
    func onNextPage() {
        disableBounce = false
        if((currentIndex <= 3 && (mType == COSMOS_MSG_TYPE_TRANSFER2 || mType == COSMOS_MSG_TYPE_REDELEGATE2 || mType == IRIS_MSG_TYPE_TRANSFER || mType == IRIS_MSG_TYPE_REDELEGATE || mType == BNB_MSG_TYPE_TRANSFER || mType == KAVA_MSG_TYPE_TRANSFER || mType == IOV_MSG_TYPE_TRANSFER || mType == BAND_MSG_TYPE_TRANSFER)) || currentIndex <= 2) {
            setViewControllers([orderedViewControllers[currentIndex + 1]], direction: .forward, animated: true, completion: { (finished) -> Void in
                self.currentIndex = self.currentIndex + 1
                let value:[String: Int] = ["step": self.currentIndex ]
                NotificationCenter.default.post(name: Notification.Name("stepChanged"), object: nil, userInfo: value)
                let currentVC = self.orderedViewControllers[self.currentIndex] as! BaseViewController
                currentVC.enableUserInteraction()
                self.disableBounce = true
            })
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) {
            
        } else {
            if let currentViewController = pageViewController.viewControllers?.first,
                let index = orderedViewControllers.index(of: currentViewController) {
                currentIndex = index
            }
            let value:[String: Int] = ["step": currentIndex]
            NotificationCenter.default.post(name: Notification.Name("stepChanged"), object: nil, userInfo: value)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(disableBounce) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(disableBounce) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func onFetchTopValidatorsInfo() {
        var url: String?
        if (chainType == ChainType.COSMOS_MAIN) {
            url = CSS_LCD_URL_VALIDATORS
        } else if (chainType == ChainType.KAVA_MAIN) {
            url = KAVA_VALIDATORS
        } else if (chainType == ChainType.KAVA_TEST) {
            url = KAVA_TEST_VALIDATORS
        } else if (chainType == ChainType.BAND_MAIN) {
            url = BAND_VALIDATORS
        } else if (chainType == ChainType.IOV_MAIN) {
            url = IOV_VALIDATORS
        } else if (chainType == ChainType.IOV_TEST) {
            url = IOV_TEST_VALIDATORS
        }
        let request = Alamofire.request(url!, method: .get, parameters: ["status":"bonded"], encoding: URLEncoding.default, headers: [:]);
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                if (self.chainType == ChainType.COSMOS_MAIN || self.chainType == ChainType.KAVA_MAIN || self.chainType == ChainType.KAVA_TEST ||
                    self.chainType == ChainType.BAND_MAIN || self.chainType == ChainType.IOV_MAIN || self.chainType == ChainType.IOV_TEST) {
                    guard let responseData = res as? NSDictionary,
                        let validators = responseData.object(forKey: "result") as? Array<NSDictionary> else {
                             print("no validators!!")
                            return
                    }
                    self.mToReDelegateValidators.removeAll()
                    for validator in validators {
                        let tempVal = Validator(validator as! [String : Any])
                        if(tempVal.operator_address != self.mTargetValidator?.operator_address) {
                            self.mToReDelegateValidators.append(tempVal)
                        }
                    }
                    self.sortByPower()
                }
                
            case .failure(let error):
                if (SHOW_LOG) { print("onFetchTopValidatorsInfo ", error) }
            }
        }
    }
    
    var irisValidatorPage = 1;
    func onFetchIrisValidatorsInfo(_ page:Int){
        let request = Alamofire.request(IRIS_LCD_URL_VALIDATORS, method: .get, parameters: ["size":"100", "page":String(page)], encoding: URLEncoding.default, headers: [:])
        request.responseJSON { (response) in
            switch response.result {
            case .success(let res):
                guard let validators = res as? Array<NSDictionary> else {
                    return
                }
                
                for validator in validators {
                    let val = Validator(validator as! [String : Any])
                    if (val.status == val.BONDED && val.operator_address != self.mTargetValidator?.operator_address) {
                        self.mToReDelegateValidators.append(val)
                    }
                }
                
                if (validators.count == 100) {
                    self.irisValidatorPage = self.irisValidatorPage + 1
                    self.onFetchIrisValidatorsInfo(self.irisValidatorPage)
                } else {
                    self.sortByPower()
                }
                
            case .failure(let error):
                print("onFetchIrisValidatorsInfo ", error)
            }
        }
    }
    
    func sortByPower() {
        mToReDelegateValidators.sort{
            if ($0.description.moniker == "Cosmostation") {
                return true
            }
            if ($1.description.moniker == "Cosmostation") {
                return false
            }
            if ($0.jailed && !$1.jailed) {
                return false
            }
            if (!$0.jailed && $1.jailed) {
                return true
            }
            return Double($0.tokens)! > Double($1.tokens)!
        }
    }
}
