package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.TranHistory;

public interface TranHistoryDao {
    int saveTranHistory(TranHistory tranHistory);

    int getHistory(String tranId);

    int deleteHistoryByTId(String tranId);
}
