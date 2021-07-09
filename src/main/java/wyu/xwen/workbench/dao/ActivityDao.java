package wyu.xwen.workbench.dao;

import org.apache.ibatis.annotations.Param;
import wyu.xwen.vo.ChartVO2;
import wyu.xwen.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getPageListByCondition(Map<String, Object> map);

    int saveActivity(Activity activity);

    Activity getActivityById(String id);

    int doUpdate(Activity activity);

    int deleteActivity(String id);

    List<Activity> getActivityByClueId(String clueId);

    List<Activity> getNotAssociatedActivity(Map<String,Object> map);

    List<Activity> getActivityList(@Param("name") String name);

    List<Activity> getActivityByContactsId(String contactsId);

    List<Activity> getActivityList2(@Param("name")String name,@Param("contactsId")String contactsId);

    List<ChartVO2> getChartDate();
}
