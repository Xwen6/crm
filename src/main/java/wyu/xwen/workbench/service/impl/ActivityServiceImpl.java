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
}
