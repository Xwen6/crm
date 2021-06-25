package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.settings.dao.UserDao;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.ActivityDao;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.service.ActivityService;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;
    @Resource
    private UserDao userDao;


    @Override
    public PageVo pageList(Map<String, Object> map) {
    /*获取市场活动的数量*/
        int total = activityDao.getTotalByCondition(map);
        /*获取市场活动列表*/
        List<Activity> pageList = activityDao.getPageListByCondition(map);
        PageVo pageVo = new PageVo();
        pageVo.setPageList(pageList);
        pageVo.setTotal(total);
        return pageVo;
    }

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    /*保存活动*/

    @Override
    public Boolean saveActivity(Activity activity) {
        if (activity !=null ){
         int count =  activityDao.saveActivity(activity);
         if (count>0){
             return true;
         }
         else return false;
        }
        return false;
    }

    /*修改市场活动*/

    @Override
    public Activity getActivityById(String id) {
        return activityDao.getActivityById(id);
    }

    @Override
    public Boolean doUpdate(Activity activity) {
        if (null!=activity){
           int count =  activityDao.doUpdate(activity);
           if (count>0){
               return true;
           }
           return false;
        }
        return false;
    }
}
