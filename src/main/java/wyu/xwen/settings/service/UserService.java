package wyu.xwen.settings.service;


import wyu.xwen.exception.LoginException;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;


import java.util.List;

public interface UserService {
    User login(String loginAct, String md5loginPwd, String loginIp) throws LoginException;

    List<User> selectUserList() throws SelectUserListException;
}
