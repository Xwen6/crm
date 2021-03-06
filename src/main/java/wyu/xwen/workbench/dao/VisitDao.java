package wyu.xwen.workbench.dao;

import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;

import java.util.List;

public interface VisitDao
{
    int addVisit(Visit visit);

    List<Visit> getVisitList();

    List<Visit> PageList(Visit visit);

    int getTotalByCondition(VisitVo visitVo);

    VisitVo getVisitById(String id);

    int updateVisit(Visit visit);

    int deleteVisit(String[] ids);
}
