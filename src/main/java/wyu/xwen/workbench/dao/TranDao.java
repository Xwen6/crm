package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.Tran;

import java.util.List;

public interface TranDao {
    int saveTran(Tran tran);

    List<Tran> getTranListByCid(String customerId);

    int deleteTran(String id);

    List<Tran> getTranListByContactsId(String contactsId);

    List<Tran> getTranListByCondition(Tran tran);

    int getTotalByCondition(Tran tran);

    int CleanContactsId(String id);

    int getCountByContacts(String id);

    Tran getTranById(String id);

    int updateTran(Tran tran);

    Tran getTranById2(String id);

    int changeStage(Tran tran);
}
