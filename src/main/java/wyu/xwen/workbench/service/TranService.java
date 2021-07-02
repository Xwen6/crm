package wyu.xwen.workbench.service;

import wyu.xwen.exception.TranDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    Object pageList(Tran tran);

    List<Customer> getCustomerByName(String name);

    List<Contacts> getContactsByName(String fullname);

    boolean saveTran(Tran tran);

    boolean deleteTran(String[] ids) throws TranDeleteException;

    Tran getTranById(String id);

    List<User> getUserList();

    boolean updateTran(Tran tran);

    Tran detail(String id);


    boolean changeStage(Tran tran);
}
