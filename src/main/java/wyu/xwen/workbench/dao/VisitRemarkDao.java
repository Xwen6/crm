package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.VisitRemark;

import java.util.List;

public interface VisitRemarkDao
{
    int addRemark(VisitRemark visitRemark);

    List<VisitRemark> getRemarkListByVisitId(String visitId);

    int editRemark(VisitRemark visitRemark);

    Boolean deleteRemark(String id);
}
