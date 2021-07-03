package wyu.xwen.settings.dao;


import org.apache.ibatis.annotations.Param;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.UserVo;

import java.util.List;
import java.util.Map;

public interface UserDao {
    List<User> selectUser();

    User login(Map<Object,Object> map);

    List<User> getUserList();

    String getUserNameById(String id);

    int updatePassword(@Param("id") String id, @Param("newPwd") String newPwd);

    List<UserVo> pageList(UserVo userVo);

    int getCount(UserVo userVo);

    Boolean addUser(UserVo userVo);

    User getUserById(String id);

    int updateUser(User user);

    Boolean deleteUser(String[] ids);
}
