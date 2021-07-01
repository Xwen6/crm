package wyu.xwen.workbench.service;

import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.CustomerRemark;
import wyu.xwen.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    PageVo pageList(Map<String, Object> map);

    boolean saveCustomer(Customer customer);

    Customer getCustomerById(String id);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomer(String[] ids);

    List<CustomerRemark> getRemarksByCId(String customerId);

    boolean updateRemark(CustomerRemark remark);

    boolean deleteRemark(String id);

    boolean saveRemark(CustomerRemark remark);

    List<Tran> showTranListByCId(String customerId);

    boolean deleteTran(String id);

    List<Contacts> getContactsByCId(String customerId);

    boolean deleteContacts(String id);

    List<Customer> getCustomerName(String name);

    boolean saveContacts(Contacts contacts);
}
