package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import wyu.xwen.exception.ActivityDeleteException;
import wyu.xwen.settings.dao.UserDao;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.ActivityDao;
import wyu.xwen.workbench.dao.ActivityRemarkDao;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.ActivityRemark;
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
    @Autowired
    private ActivityRemarkDao activityRemarkDao;


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

    /*删除市场活动*/
    /*事务*/
    @Transactional(
            propagation = Propagation.REQUIRED,
            isolation = Isolation.DEFAULT,
            readOnly = false,
            rollbackFor = {
            ActivityDeleteException.class}
    )
    @Override
    public Boolean deleteActivity(String[] ids) throws ActivityDeleteException {

        int acMarkNum1 = 0;
        int acMarkNum2 = 0;
        int acNum = 0;
        for (String id:ids
             ) {
            acMarkNum1 = activityRemarkDao.selectRMarkCount(id);
            acMarkNum2 += activityRemarkDao.deleteActivityRemark(id);
            acNum += activityDao.deleteActivity(id);
        }

        if (acMarkNum1==acMarkNum2){
            if (acNum==ids.length){
                return true;
            }
        }else throw new ActivityDeleteException("市场活动删除失败");

        return false;
    }

    /*获取备注列表*/

    @Override
    public List<ActivityRemark> getRemarkByAid(String id) {
        return activityRemarkDao.getRemarkListByAid(id);
    }

    /*更新备注*/

    @Override
    public Boolean updateRemark(ActivityRemark activityRemark) {
        if (activityRemark!=null){
            int count = activityRemarkDao.updateRemark(activityRemark);
            if (count>0){
                return true;
            }return false;
        }
        return false;
    }
    /*删除备注*/

    @Override
    public Boolean deleteRemark(String id) {
        int count = activityRemarkDao.deleteRemark(id);
        if (count>0){
            return true;
        }
        return false;
    }

    /*保存备注*/

    @Override
    public Boolean saveRemark(ActivityRemark activityRemark) {
        if (activityRemark!=null){
            int count = activityRemarkDao.saveRemark(activityRemark);
            if (count>0){
                return true;
            }return false;
        }
        return false;
    }
}
