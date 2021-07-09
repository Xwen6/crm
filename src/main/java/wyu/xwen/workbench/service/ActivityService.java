package wyu.xwen.workbench.service;

import wyu.xwen.exception.ActivityDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.ChartVO2;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    PageVo pageList(Map<String, Object> map);

    List<User> getUserList();

    Boolean saveActivity(Activity activity);

    Activity getActivityById(String id);

    Boolean doUpdate(Activity activity);

    Boolean deleteActivity(String[] ids) throws ActivityDeleteException;

    List<ActivityRemark> getRemarkByAid(String activityId);

    Boolean updateRemark(ActivityRemark activityRemark);

    Boolean deleteRemark(String id);

    Boolean saveRemark(ActivityRemark activityRemark);

    List<ChartVO2> chart();
}
