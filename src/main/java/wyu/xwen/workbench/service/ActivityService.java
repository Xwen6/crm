package wyu.xwen.workbench.service;

import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    PageVo pageList(Map<String, Object> map);

    List<User> getUserList();

    Boolean saveActivity(Activity activity);

    Activity getActivityById(String id);

    Boolean doUpdate(Activity activity);
}
