package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.ContactsDao;
import wyu.xwen.workbench.dao.CustomerDao;
import wyu.xwen.workbench.dao.CustomerRemarkDao;
import wyu.xwen.workbench.dao.TranDao;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.CustomerRemark;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.service.CustomerService;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private ContactsDao contactsDao;

    /*获取客户列表*/

    @Override
    public PageVo pageList(Map<String, Object> map) {

        int total = customerDao.getTotalByCondition(map);
        List<Customer> customers = customerDao.getCustomerByCondition(map);
        PageVo pageVo = new PageVo();
        pageVo.setPageList(customers);
        pageVo.setTotal(total);
        return pageVo;
    }

    /*添加客户*/

    @Override
    public boolean saveCustomer(Customer customer) {
        int count = customerDao.saveCustomer(customer);
        return count>0;
    }

    /*根据id查找客户
    * workbench/customer/getCustomerById.do*/

    @Override
    public Customer getCustomerById(String id) {
        return customerDao.getCustomerById(id);
    }

    /*执行更新*/

    @Override
    public boolean updateCustomer(Customer customer) {
        int count = customerDao.updateCustomer(customer);
        return count>0;
    }

    /*删除顾客*/

    @Override
    public boolean deleteCustomer(String[] ids) {
        int count = 0;
        int remarkNum = 0;
        int remarkCount = 0;
        for (String id:ids
             ) {
            remarkNum = customerRemarkDao.deleteRemarkByCId(id);
           count +=  customerDao.deleteCustomer(id);
           remarkCount += customerRemarkDao.getRemarksCount(id);
        }
        return count== ids.length;
    }

    /*获取客户备注列表*/

    @Override
    public List<CustomerRemark> getRemarksByCId(String customerId) {

        return customerRemarkDao.getRemarks(customerId);
    }

    /*更新备注*/

    @Override
    public boolean updateRemark(CustomerRemark remark) {
        int count = customerRemarkDao.updateRemark(remark);
        return count>0;
    }

    /*删除备注*/

    @Override
    public boolean deleteRemark(String id) {
        int count = customerRemarkDao.deleteRemark(id);
        return count>0;
    }

    /*新增备注*/

    @Override
    public boolean saveRemark(CustomerRemark remark) {
        int count = customerRemarkDao.saveCustomerRemark(remark);
        return count>0;
    }

    /*查找交易*/

    @Override
    public List<Tran> showTranListByCId(String customerId) {
        return tranDao.getTranListByCid(customerId);
    }

    /*删除交易*/

    @Override
    public boolean deleteTran(String id) {
        int count = tranDao.deleteTran(id);
        return count>0;
    }

    /*查找联系人*/

    @Override
    public List<Contacts> getContactsByCId(String customerId) {
        return contactsDao.getContactsListByCId(customerId);
    }

    /*删除联系人*/

    @Override
    public boolean deleteContacts(String id) {
     int count =contactsDao.deleteContacts(id);
        return count>0;
    }

    /*自动补全*/

    @Override
    public List<Customer> getCustomerName(String name) {
        return customerDao.getCustomerName(name);
    }

    /*新建联系人*/

    @Override
    public boolean saveContacts(Contacts contacts) {
        String customerName = contacts.getCustomerId();
        String customerId = customerDao.getCustomerId(customerName);
        contacts.setCustomerId(customerId);
        int count = contactsDao.saveContacts2(contacts);
        return count>0;
    }
}
