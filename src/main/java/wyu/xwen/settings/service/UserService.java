package wyu.xwen.settings.service;


import wyu.xwen.exception.LoginException;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;


import java.util.List;

public interface UserService {
    User login(String loginAct, String md5loginPwd, String loginIp) throws LoginException;

    /*获取所有的用户*/
    List<User> selectUserList() throws SelectUserListException;
    /*根据名字获取Id*/
    String getUserNameById(String id);
    /*修改用户密码*/
    boolean updatePassword(String id, String newPwd);
}
