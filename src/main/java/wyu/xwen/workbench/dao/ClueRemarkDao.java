package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    int deleteClueRemark(String id);

    int selectRMarkCount(String id);

    List<ClueRemark> getRemarkByClueId(String clueId);

    int updateRemark(ClueRemark remark);

    int deleteRemarkById(String id);

    int saveRemark(ClueRemark remark);
}
