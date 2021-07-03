package wyu.xwen.settings.service;


import wyu.xwen.exception.LoginException;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.UserVo;


import java.util.List;

public interface UserService {
    User login(String loginAct, String md5loginPwd, String loginIp) throws LoginException;

    /*获取所有的用户*/
    List<User> selectUserList() throws SelectUserListException;
    /*根据名字获取Id*/
    String getUserNameById(String id);
    /*修改用户密码*/
    boolean updatePassword(String id, String newPwd);
    /*页面展示*/
    List<UserVo> pageList(UserVo userVo);
    /*获取符合条件的人数*/
    int getCount(UserVo userVo);

    Boolean addUser(UserVo userVo);

    User getUserById(String id);

    Boolean updateUser(User user);

    Boolean deleteUser(String[] ids);
}
