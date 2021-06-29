package wyu.xwen.workbench.service;

import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.domain.VisitRemark;

import java.util.List;

public interface VisitService
{
    boolean addVisit(Visit visit);

    List<Visit> getVisitList();

    List<Visit> PageList(Visit visit);

    int getCount(VisitVo visitVo);

    VisitVo getVisitById(String id);

    boolean updateVisit(Visit visit);

    Boolean deleteVisit(String[] ids);

    Boolean addRemark(VisitRemark visitRemark);

    List<VisitRemark> getRemarkListByVisitId(String visitId);

    Boolean editRemark(VisitRemark visitRemark);

    Boolean deleteRemark(String id);
}
