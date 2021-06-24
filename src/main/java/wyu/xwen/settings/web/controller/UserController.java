package wyu.xwen.settings.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.exception.LoginException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.settings.service.UserService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
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

    @RequestMapping(value = "/login.do",method = RequestMethod.POST)
    @ResponseBody
    public Object login(String loginAct,String loginPwd,HttpServletRequest request){

        String loginIp = request.getRemoteAddr();
        Map<Object,Object> map = new HashMap<>();
        Boolean success = false;
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
}
