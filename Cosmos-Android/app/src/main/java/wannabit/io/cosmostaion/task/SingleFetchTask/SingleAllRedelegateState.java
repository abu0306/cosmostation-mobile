package wannabit.io.cosmostaion.task.SingleFetchTask;

import org.json.JSONObject;

import java.util.ArrayList;

import retrofit2.Response;
import wannabit.io.cosmostaion.base.BaseApplication;
import wannabit.io.cosmostaion.base.BaseChain;
import wannabit.io.cosmostaion.base.BaseConstant;
import wannabit.io.cosmostaion.dao.Account;
import wannabit.io.cosmostaion.model.type.Redelegate;
import wannabit.io.cosmostaion.network.ApiClient;
import wannabit.io.cosmostaion.network.res.ResLcdRedelegate;
import wannabit.io.cosmostaion.task.CommonTask;
import wannabit.io.cosmostaion.task.TaskListener;
import wannabit.io.cosmostaion.task.TaskResult;
import wannabit.io.cosmostaion.utils.WLog;

public class SingleAllRedelegateState extends CommonTask {

    private Account mAccount;
    private String  mFromAddress;
    private String  mToAddress;

    public SingleAllRedelegateState(BaseApplication app, TaskListener listener, Account mAccount, String mFromAddress, String mToAddress) {
        super(app, listener);
        this.mAccount = mAccount;
        this.mFromAddress = mFromAddress;
        this.mToAddress = mToAddress;
        this.mResult.taskType   = BaseConstant.TASK_FETCH_SINGLE_ALL_REDELEGATE;
    }

    @Override
    protected TaskResult doInBackground(String... strings) {
        try {
            if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.COSMOS_MAIN)) {
                Response<ResLcdRedelegate> response = ApiClient.getCosmosChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            } else if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.KAVA_MAIN)) {
                Response<ResLcdRedelegate> response = ApiClient.getKavaChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            } else if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.KAVA_TEST)) {
                Response<ResLcdRedelegate> response = ApiClient.getKavaTestChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            } else if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.BAND_MAIN)) {
                Response<ResLcdRedelegate> response = ApiClient.getBandChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            } else if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.IOV_MAIN)) {
                Response<ResLcdRedelegate> response = ApiClient.getIovChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            } else if (BaseChain.getChain(mAccount.baseChain).equals(BaseChain.IOV_TEST)) {
                Response<ResLcdRedelegate> response = ApiClient.getIovTestChain(mApp).getRedelegateAllHistory(mAccount.address, mFromAddress, mToAddress).execute();
                if(response.isSuccessful()) {
                    if(response.body() != null && response.body().result != null) {
                        mResult.resultData = response.body().result;
                        mResult.isSuccess = true;
                    } else {
                        mResult.resultData = new ArrayList<Redelegate>();
                        mResult.isSuccess = true;
                    }
                }

            }



        } catch (Exception e) {
            WLog.w("SingleAllRedelegateState Error " + e.getMessage());
            if(BaseConstant.IS_SHOWLOG) e.printStackTrace();
        }
        return mResult;
    }

}