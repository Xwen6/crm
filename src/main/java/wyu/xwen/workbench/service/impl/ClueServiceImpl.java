package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import wyu.xwen.exception.ClueDeleteException;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.ActivityDao;
import wyu.xwen.workbench.dao.ClueActivityRelationDao;

import wyu.xwen.workbench.dao.ClueDao;
import wyu.xwen.workbench.dao.ClueRemarkDao;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.Clue;
import wyu.xwen.workbench.domain.ClueActivityRelation;
import wyu.xwen.workbench.domain.ClueRemark;
import wyu.xwen.workbench.service.ClueService;

import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;

    @Override
    public Object pageList(Map<String,Object> map) {
        int total = clueDao.getTotalByCondition(map);
        /*获取市场活动列表*/
        List<Clue> pageList = clueDao.getPageListByCondition(map);
        PageVo pageVo = new PageVo();
        pageVo.setPageList(pageList);
        pageVo.setTotal(total);
        return pageVo;
    }

    /*保存线索*/
    @Override
    public Boolean saveClue(Clue clue) {
       int count = clueDao.saveClue(clue);
       if (count>0){
        return true;
       }
        return false;
    }

    /*根据id获取线索*/

    @Override
    public Clue getClueById(String id) {

        return clueDao.getClueById(id);
    }

    /*更新线索*/

    @Override
    public Boolean updateClue(Clue clue) {

        if (clue!=null){
          int count = clueDao.updateClue(clue);
          if (count>0){
              return true;
          }return false;
        }


        return false;
    }

    /*删除*/

    @Transactional(
            propagation = Propagation.REQUIRED,
            isolation = Isolation.DEFAULT,
            readOnly = false,
            rollbackFor = {
                    ClueDeleteException.class}
    )
    @Override
    public Boolean deleteClue(String[] ids) throws ClueDeleteException {
        int acMarkNum1 = 0;
        int acMarkNum2 = 0;
        int acNum = 0;
        for (String id:ids
        ) {
            acMarkNum1 = clueRemarkDao.selectRMarkCount(id);
            acMarkNum2 += clueRemarkDao.deleteClueRemark(id);
            acNum += clueDao.deleteClue(id);
        }

        if (acMarkNum1==acMarkNum2){
            if (acNum==ids.length){
                return true;
            }
        }else throw new ClueDeleteException("线索删除失败");

        return false;
    }

    /*获取线索备注列表*/

    @Override
    public List<ClueRemark> getClueRemarkByClueId(String clueId) {
      return clueRemarkDao.getRemarkByClueId(clueId);
    }

    /*修改线索*/

    @Override
    public Boolean updateRemark(ClueRemark remark) {
        if (remark!=null){
            int count = clueRemarkDao.updateRemark(remark);
            if (count>0)return true;
            else return false;
        }
        return false;
    }

    /*删除备注*/

    @Override
    public Boolean deleteRemark(String id) {

        int count = clueRemarkDao.deleteRemarkById(id);
        return count > 0;
    }
    /*添加备注*/

    @Override
    public Boolean saveRemark(ClueRemark remark) {

        if (remark!=null){
            int count = clueRemarkDao.saveRemark(remark);
            return count>0;
        }
        return false;
    }

    /*获取已和线索关联的市场活动*/

    @Override
    public List<Activity> getActivityByClueId(String clueId) {

        return activityDao.getActivityByClueId(clueId);
    }

    /*解除关联*/

    @Override
    public Boolean relieve(String id) {
        int count = clueActivityRelationDao.deleteRelation(id);
        return count>0;
    }

    /*获取为关联的市场活动*/

    @Override
    public List<Activity> notAssociated(Map<String,Object> map) {
        return activityDao.getNotAssociatedActivity(map);
    }
    /*新增联系*/

    @Override
    public Boolean saveRelation(String[] activityId, String clueId) {
        int count = 0 ;
        for (String aid:activityId
             ) {
            ClueActivityRelation relation = new ClueActivityRelation(UUIDUtil.getUUID(),clueId,aid);
           count += clueActivityRelationDao.addRelation(relation);
        }
        return count==activityId.length;

    }
}
