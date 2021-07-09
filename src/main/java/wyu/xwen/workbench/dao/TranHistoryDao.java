package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    int saveTranHistory(TranHistory tranHistory);

    int getHistory(String tranId);

    int deleteHistoryByTId(String tranId);

    List<TranHistory> getTranHistoryByTranId(String id);
}
