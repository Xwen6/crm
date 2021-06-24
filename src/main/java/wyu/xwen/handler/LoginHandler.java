package wyu.xwen.handler;

import org.springframework.web.servlet.HandlerInterceptor;
import wyu.xwen.settings.domain.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/*登录验证*/
public class LoginHandler implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        /*关于登录的请求，放行*/
        String url =  request.getRequestURI();
        // 截取其中的方法名
        String methodName = url.substring(url.lastIndexOf("/")+1, url.lastIndexOf("."));
        if (methodName.contains("toLogin")||methodName.contains("login")){
            return true;
        }
        User user = (User) request.getSession().getAttribute("user");
        if (user==null){
            request.getRequestDispatcher("/web/system/toLogin.do").forward(request,response);
        }
        return true;
    }
}
