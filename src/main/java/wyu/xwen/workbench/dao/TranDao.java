package wyu.xwen.workbench.dao;

import wyu.xwen.vo.ChartVO2;
import wyu.xwen.vo.ChartVo;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

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


    String getStageById(String id);

    List<ChartVo> getDate();


   List<ChartVO2> getChartDate2();

    List<ChartVo> getChartDate3();

    List<ChartVO2> getChartDate4();
}
