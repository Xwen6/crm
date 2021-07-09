package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {
    int getRemarkCount(String tranId);

    int deleteTranRemarkByTId(String tranId);

    List<TranRemark> getRemarkList(String tranId);

    int updateRemark(TranRemark remark);

    int deleteRemark(String id);

    int saveRemark(TranRemark remark);
}
