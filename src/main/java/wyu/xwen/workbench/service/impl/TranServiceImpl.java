package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.exception.TranDeleteException;
import wyu.xwen.settings.dao.UserDao;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.*;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.domain.TranHistory;
import wyu.xwen.workbench.service.TranService;

import java.util.List;

@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranDao tranDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private TranRemarkDao tranRemarkDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private UserDao userDao;


    /*pageList*/
    @Override
    public Object pageList(Tran tran) {
        PageVo pageVo = new PageVo();
       /* String customerId = customerDao.getCustomerId(tran.getCustomerName());
        tran.setCustomerId(customerId);*/
        int total = tranDao.getTotalByCondition(tran);
        List<Tran> trans = tranDao.getTranListByCondition(tran);
        pageVo.setPageList(trans);
        pageVo.setTotal(total);
        return pageVo;
    }

    /*模糊查询*/

    @Override
    public List<Customer> getCustomerByName(String name) {
        return customerDao.getCustomerName(name);
    }

    /*获取联系人列表*/

    @Override
    public List<Contacts> getContactsByName(String fullname) {
        return contactsDao.getContactsListByName(fullname);
    }

    /*创建交易*/

    @Override
    public boolean saveTran(Tran tran) {
        int count1 = 0;
        int count2 = 0;
       Customer customer1 =  customerDao.getCustomerByName(tran.getContactsName());
        if (customer1==null){
            Customer customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(tran.getCreateBy());
            customer.setOwner(tran.getOwner());
            customer.setName(tran.getCustomerName());
            tran.setCustomerId(customer.getId());
            count1 =  customerDao.saveCustomer(customer);
            customer1 = customer;
        }

        tran.setCustomerId(customer1.getId());
        if (count1>0){
           count2 =  tranDao.saveTran(tran);
        }
        /*创建交易的同时，创建交易历史*/
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setStage(tran.getStage());
        int count3 = tranHistoryDao.saveTranHistory(tranHistory);
        return count1>0&&count2>0&count3>0;
    }
    /*删除交易*/

    @Override
    public boolean deleteTran(String[] ids) throws TranDeleteException {
        /*删除交易之前要删除交易的备注以及交易李四*/
        int remarkCount = 0;
        int deleteRemark = 0;
        int tranHistoryCount = 0;
        int deleteHistory = 0;
        int tranCount = 0;
        for (String tranId:ids
             ) {
            remarkCount += tranRemarkDao.getRemarkCount(tranId);
            deleteRemark += tranRemarkDao.deleteTranRemarkByTId(tranId);
            tranHistoryCount += tranHistoryDao.getHistory(tranId);
            deleteHistory += tranHistoryDao.deleteHistoryByTId(tranId);
            tranCount += tranDao.deleteTran(tranId);
        }

        if (remarkCount!=deleteRemark&&tranHistoryCount!=deleteHistory&&tranCount!= ids.length){
            throw new TranDeleteException("交易删除失败");
        }
        return true;

    }

    @Override
    public Tran getTranById(String id) {
        return tranDao.getTranById(id);
    }

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }

    @Override
    public boolean updateTran(Tran tran) {
        int count1 = 0;
        int count2 = 0;
        Customer customer1 =  customerDao.getCustomerByName(tran.getContactsName());
        if (customer1==null){
            Customer customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(tran.getCreateBy());
            customer.setOwner(tran.getOwner());
            customer.setName(tran.getCustomerName());
            tran.setCustomerId(customer.getId());
            count1 =  customerDao.saveCustomer(customer);
            customer1 = customer;
        }
        tran.setCustomerId(customer1.getId());
        if (count1>0){
            count2 =  tranDao.updateTran(tran);
        }
        return count1>0&&count2>0;
    }

    @Override
    public Tran detail(String id) {
        return tranDao.getTranById2(id);
    }

    @Override
    public boolean changeStage(Tran tran) {

        int count = tranDao.changeStage(tran);
        Tran tran1 = tranDao.getTranById(tran.getId());
        /*创建交易的同时，创建交易历史*/
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran1.getId());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setMoney(tran1.getMoney());
        tranHistory.setExpectedDate(tran1.getExpectedDate());
        tranHistory.setCreateBy(tran1.getCreateBy());
        tranHistory.setStage(tran1.getStage());
        int count3 = tranHistoryDao.saveTranHistory(tranHistory);
        return count>0&&count3>0;

    }
}
