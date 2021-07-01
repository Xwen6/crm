package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.ContactsDao;
import wyu.xwen.workbench.dao.ContactsRemarkDao;
import wyu.xwen.workbench.dao.CustomerDao;
import wyu.xwen.workbench.dao.TranDao;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.ContactsRemark;
import wyu.xwen.workbench.domain.Tran;
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

    @Override
    public boolean deleteContacts(String[] ids) {
        int count = 0;
        for (String id:ids
             ) {
            count += contactsDao.deleteContacts(id);
        }
        return count==ids.length;
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
}
