package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.Tran;

import java.util.List;

public interface TranDao {
    int saveTran(Tran tran);

    List<Tran> getTranListByCid(String customerId);

    int deleteTran(String id);

    List<Tran> getTranListByContactsId(String contactsId);
}
