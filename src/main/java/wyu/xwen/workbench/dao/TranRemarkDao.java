package wyu.xwen.workbench.dao;

public interface TranRemarkDao {
    int getRemarkCount(String tranId);

    int deleteTranRemarkByTId(String tranId);
}
