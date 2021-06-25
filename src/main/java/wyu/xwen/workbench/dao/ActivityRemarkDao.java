package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int deleteActivityRemark(String id);

    int selectRMarkCount(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    int updateRemark(ActivityRemark activityRemark);

    int deleteRemark(String id);

    int saveRemark(ActivityRemark activityRemark);
}
