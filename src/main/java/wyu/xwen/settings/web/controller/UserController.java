package wyu.xwen.settings.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.exception.LoginException;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.settings.service.DepartmentService;
import wyu.xwen.settings.service.UserService;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.UserVo;
import wyu.xwen.workbench.domain.Visit;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("settings/user")
public class UserController{
    /*@Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url =  request.getRequestURI();
        // 截取其中的方法名
        String methodName = url.substring(url.lastIndexOf("/")+1, url.lastIndexOf("."));
        *//*if ("login".equals(methodName)){
            login(request,response);
        }*//*
        Method method = null;
        try {
            // 使用反射机制获取在本类中声明了的方法
            method = getClass().getDeclaredMethod(methodName, HttpServletRequest.class, HttpServletResponse.class);
            // 执行方法
            method.invoke(this, request, response);
        } catch (Exception e) {
            throw new RuntimeException("调用方法出错！");
        }
    }*/
    @Autowired
    private UserService userService;

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping(value = "/login.do",method = RequestMethod.POST)
    @ResponseBody
    public Object login(String loginAct,String loginPwd,HttpServletRequest request){

        String loginIp = request.getRemoteAddr();
        Map<Object,Object> map = new HashMap<>();
        boolean success = false;
        try {
            User user = userService.login(loginAct,loginPwd,loginIp);
            request.getSession().setAttribute("user",user);
            success = true;
            map.put("success",success);
            return  map;

        } catch (LoginException e) {
            String msg = e.getMessage();

            map.put("success",success);
            map.put("msg",msg);
            return map;
        }

    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public Map<String,Object> pageList(UserVo userVo) throws SelectUserListException
    {
        Integer skinPage = (userVo.getPageNo() - 1) * userVo.getPageSize();
        if ("锁定".equals(userVo.getLockState()))
        {
            userVo.setLockState("0");
        }
        else
        {
            userVo.setLockState("1");
        }
        userVo.setSkipPage(skinPage);
        List<UserVo> list = userService.pageList(userVo);
        int count = userService.getCount(userVo);
        for (UserVo u:list)
        {
            if (u.getCreateBy() != null)
            {
                u.setCreateName(userService.getUserNameById(u.getCreateBy()));
            }
            if (u.getEditBy() != null)
            {
                u.setEditName(userService.getUserNameById(u.getEditBy()));
            }
        }
        Map<String,Object> map = new HashMap<>();
        map.put("list",list);
        map.put("total",count);
        return map;
    }

    /*添加用户*/
    @RequestMapping("addUser.do")
    @ResponseBody
    public Boolean addUser(UserVo userVo)
    {
        userVo.setId(UUIDUtil.getUUID());
        userVo.setCreateTime(DateTimeUtil.getSysTime());
        if (userVo.getLockState() != null && "锁定".equals(userVo.getLockState()))
        {
            userVo.setLockState("0");
        }
        else
        {
            userVo.setLockState("1");
        }
        if (userVo.getDeptName() != null)
        {
            userVo.setDeptno(departmentService.getDeptIdByName(userVo.getDeptName()));
        }
        return userService.addUser(userVo);
    }

    /*获取用户*/
    @RequestMapping("/getUserById.do")
    @ResponseBody
    public User getUserById(String id)
    {
        return userService.getUserById(id);
    }

    /*编辑用户*/
    @RequestMapping("/updateUser.do")
    @ResponseBody
    public Boolean updateUser(User user)
    {
        user.setEditTime(DateTimeUtil.getSysTime());
        if (user.getDeptno() != null)
        {
            user.setDeptno(departmentService.getDeptIdByName(user.getDeptno()));
        }
        if ("锁定".equals(user.getLockState()))
        {
            user.setLockState("0");
        }
        else
        {
            user.setLockState("1");
        }
        return userService.updateUser(user);
    }

    /*删除用户*/
    @RequestMapping("/deleteUser.do")
    @ResponseBody
    public Boolean deleteUser(String[] ids)
    {
        return userService.deleteUser(ids);
    }
}
