package wyu.xwen.settings.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.settings.dao.UserDao;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.MD5Util;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.exception.LoginException;
import wyu.xwen.exception.SelectUserListException;


import wyu.xwen.settings.service.UserService;
import wyu.xwen.vo.UserVo;


import java.util.HashMap;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userdao;

    @Override
    public User login(String loginAct, String loginPwd, String loginIp) throws LoginException {
        String md5loginPwd = MD5Util.getMD5(loginPwd);
        Map<Object, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("md5LoginPwd", md5loginPwd);
        User user = userdao.login(map);
        if (user==null){
            throw new LoginException("账号密码错误");
        }
        else if (!user.getAllowIps().contains(loginIp)){
            throw new LoginException("IP地址异常");
        }
        else if ("0".equals(user.getLockState())){
            throw new LoginException("该账号已被锁定");
        }
        else if (user.getExpireTime().compareTo(DateTimeUtil.getSysTime())<0){
            throw new LoginException("该账号已失效");
        }

        return user;
    }

    public List<User> selectUserList() throws SelectUserListException {
        List<User> userList = userdao.selectUser();
        if (userList.isEmpty()){
            throw new SelectUserListException("查询失败");
        }
        return userList;
    }

    @Override
    public String getUserNameById(String id)
    {
        return userdao.getUserNameById(id);
    }

    @Override
    public boolean updatePassword(String id, String newPwd)
    {
        int count = userdao.updatePassword(id,newPwd);
        return count == 1;
    }

    @Override
    public List<UserVo> pageList(UserVo userVo)
    {
        return userdao.pageList(userVo);
    }

    @Override
    public int getCount(UserVo userVo)
    {
        return userdao.getCount(userVo);
    }

    @Override
    public Boolean addUser(UserVo userVo)
    {
        return userdao.addUser(userVo);
    }

    @Override
    public User getUserById(String id)
    {
        return userdao.getUserById(id);
    }

    @Override
    public Boolean updateUser(User user)
    {
        int count = userdao.updateUser(user);
        return count == 1;
    }

    @Override
    public Boolean deleteUser(String[] ids)
    {
        return userdao.deleteUser(ids);
    }
}

