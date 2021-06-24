package wyu.xwen.workbench.service;

import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.PageVo;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    PageVo pageList(Map<String, Object> map);

    List<User> getUserList();
}
