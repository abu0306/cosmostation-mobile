package wannabit.io.cosmostaion.task.FetchTask;

import java.util.ArrayList;

import retrofit2.Response;
import wannabit.io.cosmostaion.base.BaseApplication;
import wannabit.io.cosmostaion.base.BaseChain;
import wannabit.io.cosmostaion.base.BaseConstant;
import wannabit.io.cosmostaion.network.ApiClient;
import wannabit.io.cosmostaion.network.res.ResLcdProposalVoted;
import wannabit.io.cosmostaion.task.CommonTask;
import wannabit.io.cosmostaion.task.TaskListener;
import wannabit.io.cosmostaion.task.TaskResult;
import wannabit.io.cosmostaion.utils.WLog;

public class ProposalVotedListTask extends CommonTask {

    private BaseChain mChain;
    private int mProposalId;

    public ProposalVotedListTask(BaseApplication app, TaskListener listener, int proposalId, BaseChain chain) {
        super(app, listener);
        this.mProposalId = proposalId;
        this.mChain = chain;
        this.mResult.taskType   = BaseConstant.TASK_FETCH_PROPOSAL_VOTED;
    }


    @Override
    protected TaskResult doInBackground(String... strings) {
        try {
            if (mChain.equals(BaseChain.COSMOS_MAIN)) {
                Response<ArrayList<ResLcdProposalVoted>> response = ApiClient.getCosmosChain(mApp).getVotedList(mProposalId).execute();
                if(!response.isSuccessful()) {
                    mResult.isSuccess = false;
                    mResult.errorCode = BaseConstant.ERROR_CODE_NETWORK;
                    return mResult;
                }

                if(response.body() != null) {
                    mResult.resultData = response.body();
                    mResult.isSuccess = true;
                }
            }

        } catch (Exception e) {
            WLog.w("ProposalVotedListTask Error " + e.getMessage());
        }

        return mResult;
    }
}