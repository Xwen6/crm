package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getPageListByCondition(Map<String, Object> map);

    int saveActivity(Activity activity);

    Activity getActivityById(String id);

    int doUpdate(Activity activity);
}
