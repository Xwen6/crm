package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    int saveCustomerRemark(CustomerRemark customerRemark);

    List<CustomerRemark> getRemarks(String customerId);

    int updateRemark(CustomerRemark remark);

    int deleteRemark(String id);

    int deleteRemarkByCId(String id);

    int getRemarksCount(String id);
}
