package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {
    Customer getCustomerByName(String company);

    int saveCustomer(Customer customer1);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerByCondition(Map<String, Object> map);

    Customer getCustomerById(String id);

    int updateCustomer(Customer customer);

    int deleteCustomer(String id);

    List<Customer> getCustomerName(String name);

    String getCustomerId(String customerName);
}
