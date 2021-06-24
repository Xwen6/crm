package wyu.xwen.settings.dao;


import wyu.xwen.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    List<User> selectUser();

    User login(Map<Object,Object> map);

}
