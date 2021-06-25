package wyu.xwen.web.listener;

import org.springframework.web.context.support.WebApplicationContextUtils;
import wyu.xwen.settings.domain.DicValue;
import wyu.xwen.settings.service.DicService;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

@WebListener
public class DicListener implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        /*初始化数据字典*/
        System.out.println("初始化数据字典");
        DicService dicService = Objects.requireNonNull(WebApplicationContextUtils.getWebApplicationContext(servletContextEvent.getServletContext())).getBean(DicService.class);
        Map<String,Object> dicMap = dicService.getDic();
        /*放到全局作用域对象*/
        ServletContext application =  servletContextEvent.getServletContext();
        System.out.println("----->"+dicMap.size());
        Set<String> keys = dicMap.keySet();
        for (String key:keys
        ) {
            List<DicValue> dicList = (List<DicValue>) dicMap.get(key);
            application.setAttribute(key,dicList);

        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
