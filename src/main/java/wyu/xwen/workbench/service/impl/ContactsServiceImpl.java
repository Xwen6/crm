package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import wyu.xwen.exception.ClueDeleteException;
import wyu.xwen.exception.ContactsDeleteException;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.*;
import wyu.xwen.workbench.domain.*;
import wyu.xwen.workbench.service.ContactsService;

import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService
{
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsRemarkDao contactsRemarkDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Override
    public List<Contacts> getContactsList()
    {
        return contactsDao.getContactsList();
    }

    @Override
    public List<Contacts> getContactsListByName(String name)
    {
        return contactsDao.getContactsListByName(name);
    }

    @Override
    public PageVo pageList(Map<String, Object> map) {
        int total = contactsDao.getTotalByCondition(map);
        List<Contacts> contactsList = contactsDao.getContactsListByCondition(map);
        PageVo pageVo = new PageVo();
        pageVo.setPageList(contactsList);
        pageVo.setTotal(total);
        return pageVo;
    }

    /*修改模态窗口的填充*/

    @Override
    public Contacts getContactsById(String id) {
        return contactsDao.getContactsListById(id);
    }

    /*执行更新*/

    @Override
    public boolean updateContacts(Contacts contacts) {
        String customerId = customerDao.getCustomerId(contacts.getCustomerName());
        contacts.setCustomerId(customerId);
        return contactsDao.updateContacts(contacts);
    }

    /*删除联系人*/
    @Transactional(
            propagation = Propagation.REQUIRED,
            isolation = Isolation.DEFAULT,
            readOnly = false,
            rollbackFor = {
                    ContactsDeleteException.class}
    )
    @Override
    public boolean deleteContacts(String[] ids) throws ContactsDeleteException {
        int acMarkNum1 = 0;
        int acMarkNum2 = 0;
        int tranCount = 0;
        int tranNum = 0;
        int activityRelationNum = 0;
        int acNum = 0;
        for (String id:ids
        ) {
            acMarkNum1 += contactsRemarkDao.selectRMarkCount(id);
            acMarkNum2 += contactsRemarkDao.deleteRemarkByContactsId(id);
            tranCount += tranDao.getCountByContacts(id);
            tranNum += tranDao.CleanContactsId(id);
            activityRelationNum = contactsActivityRelationDao.relieveRelationByContactsId(id);
            acNum += contactsDao.deleteContacts(id);
        }
        if (acMarkNum1==acMarkNum2&&tranNum==tranCount&&activityRelationNum>0){

               return   acNum==ids.length;

        }else throw new ContactsDeleteException("联系人删除失败");



      /*  int count = 0;
        for (String id:ids
             ) {
            count += contactsDao.deleteContacts(id);
        }*/

    }

    @Override
    public List<ContactsRemark> getRemarkByCId(String contactsId) {
        return contactsRemarkDao.getRemarkByCId(contactsId);
    }

    /*修改备注*/

    @Override
    public boolean updateRemark(ContactsRemark remark) {
        int count =  contactsRemarkDao.updateRemark(remark);
        return count>0;
    }

    /*删除*/
    @Override
    public boolean deleteRemark(String id) {
        int count = contactsRemarkDao.deleteRemark(id);
        return count>0;
    }

    /*新增备注*/

    @Override
    public boolean saveRemark(ContactsRemark remark) {
        int count = contactsRemarkDao.saveContactsRemark(remark);
        return count>0;
    }

    /*交易列表*/

    @Override
    public List<Tran> getTranList(String contactsId) {
        return tranDao.getTranListByContactsId(contactsId);
    }

    /*删除交易*/

    @Override
    public boolean deleteTran(String tranId) {
        int count = tranDao.deleteTran(tranId);
        return count>0;
    }

    /*获取市场活动列表*/

    @Override
    public List<Activity> getActivityListByCId(String contactsId) {
        return activityDao.getActivityByContactsId(contactsId);
    }

    @Override
    public boolean relieveRelation(String id) {
        int count  = contactsActivityRelationDao.relieveRelation(id);
        return count>0;
    }

    /*查找为关联的市场活动*/
    @Override
    public List<Activity> getActivityList(String name, String contactsId) {
        return activityDao.getActivityList2(name,contactsId);
    }

    /*保存联系*/

    @Override
    public boolean saveRelation(String[] activityIds, String contactsId) {
        int count = 0;
        for (String activityId:activityIds
             ) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setContactsId(contactsId);
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setId(UUIDUtil.getUUID());
           count += contactsActivityRelationDao.saveRelation(contactsActivityRelation);
        }
        return count==activityIds.length;
    }
}
