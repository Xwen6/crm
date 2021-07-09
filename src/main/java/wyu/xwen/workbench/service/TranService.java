package wyu.xwen.workbench.service;

import wyu.xwen.exception.TranDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.ChartVO2;
import wyu.xwen.vo.ChartVo;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.*;

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

    Tran updateTran(Tran tran);

    Tran detail(String id);


    boolean changeStage(Tran tran);

    List<TranHistory> getTranHistory(String id);

    List<TranRemark> getTranRemarks(String tranId);

    boolean updateRemark(TranRemark remark);

    boolean deleteRemark(String id);

    boolean saveRemark(TranRemark remark);

    List<ChartVo> getCharData();

    List<ChartVO2> getCharData2();

    List<ChartVo> getCharData3();

    List<ChartVO2> getCharData4();
}
