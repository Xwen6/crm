package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import wyu.xwen.exception.CLueConvertException;
import wyu.xwen.exception.ClueDeleteException;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.*;

import wyu.xwen.workbench.domain.*;
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
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Autowired
    private  TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;


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
    /*获取市场活动源*/

    @Override
    public List<Activity> getActivityList(String name) {
        return activityDao.getActivityList(name);
    }

    /*z转换*/
    @Transactional(
            propagation = Propagation.REQUIRED,
            isolation = Isolation.DEFAULT,
            readOnly = false,
            rollbackFor = {
                    CLueConvertException.class}
    )
    @Override
    public Boolean convert(String clueId, Tran tran, String createBy) throws CLueConvertException {
        String createTime = DateTimeUtil.getSysTime();
        /*根据线索id查询线索*/
        Clue clue =  clueDao.getClueById2(clueId);
        String company = clue.getCompany();
        /*根据公司名称查询该客户是否存在*/
        Customer customer = customerDao.getCustomerByName(company);
        /*如果不存在，则创建客户*/
        if (customer==null){
            Customer customer1 = new Customer();
            customer1.setName(clue.getCompany());
            customer1.setAddress(clue.getAddress());
            customer1.setContactSummary(clue.getContactSummary());
            customer1.setCreateBy(createBy);
            customer1.setCreateTime(createTime);
            customer1.setId(UUIDUtil.getUUID());
            customer1.setDescription(clue.getDescription());
            customer1.setOwner(clue.getOwner());
            customer1.setNextContactTime(clue.getNextContactTime());
            customer1.setPhone(clue.getPhone());
            customer1.setWebsite(clue.getWebsite());
            int count1 = customerDao.saveCustomer(customer1);
            if (count1!=1){
                throw new CLueConvertException("客户创建失败");
            }
            customer = customerDao.getCustomerByName(company);
        }
        /*创造联系人*/
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setContactSummary(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setSource(clue.getSource());
        int count2 = contactsDao.saveContacts(contacts);
        if (count2!=1){
            throw new CLueConvertException("联系人创建失败");
        }
        /*根据cluedId查询备注列表*/
        List<ClueRemark> clueRemarks = clueRemarkDao.getRemarkByClueId(clueId);
        /*转换为客户备注*/
        CustomerRemark customerRemark = new CustomerRemark();
        /*转换为联系人备注*/
        ContactsRemark contactsRemark = new ContactsRemark();
        for (ClueRemark c:clueRemarks
        ) {
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateBy(createBy);
            customerRemark.setNoteContent(c.getNoteContent());
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            int count3 =  customerRemarkDao.saveCustomerRemark(customerRemark);
            if (count3!=1){
                throw new CLueConvertException("客户备注创建失败");
            }

            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setNoteContent(c.getNoteContent());
            contactsRemark.setEditFlag("0");
            int count4 = contactsRemarkDao.saveContactsRemark(contactsRemark);
            if (count4!=1){
                throw new CLueConvertException("联系人备注创建失败");
            }
        }

        /*根据clueId查询市场活动关联关系*/
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationDao.getClueActivityRelationByClueId(clueId);
        /*转换为联系人市场活动关联*/
        ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
        for (ClueActivityRelation car:clueActivityRelations
        ) {
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(car.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            int count =  contactsActivityRelationDao.saveRelation(contactsActivityRelation);
            if (count!=1){
                throw new CLueConvertException("联系人和市场活动关系创建失败");
            }
        }

        if (tran!=null){
            /*已添加setId，money，name，expectedDate，stage，activityId，createTime*/
            tran.setOwner(clue.getOwner());
            tran.setSource(clue.getSource());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setCustomerId(customer.getId());
            tran.setContactsId(contacts.getId());
            tran.setContactSummary(clue.getContactSummary());
            int count5 =  tranDao.saveTran(tran);
            if (count5!=1){
                throw new CLueConvertException("交易创建失败");
            }
            /*创建交易的同时，创建交易历史*/
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setTranId(tran.getId());
            tranHistory.setCreateTime(createTime);
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateBy(createBy);
            tranHistory.setStage(tran.getStage());
            int count6 = tranHistoryDao.saveTranHistory(tranHistory);
            if (count6!=1){
                throw new CLueConvertException("交易历史创建失败");
            }
        }
        /*删除线索备注*/
        int count8 = clueRemarkDao.deleteClueRemark(clueId);
         /*删除线索和市场活动的关系*/
        int count9 = clueActivityRelationDao.deleteRelationByClueId(clueId);
     /*   删除线索*/
        if (count8==clueRemarks.size()&&count9==clueActivityRelations.size()){
            int count10 = clueDao.deleteClue(clueId);
            if (count10!=1){
                throw new CLueConvertException("线索备注删除失败");
            }
        }


        return true;
    }
}
