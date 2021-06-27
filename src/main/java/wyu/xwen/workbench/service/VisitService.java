package wyu.xwen.workbench.service;

import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;

import java.util.List;

public interface VisitService
{
    boolean addVisit(Visit visit);

    List<Visit> getVisitList();

    List<Visit> PageList(Visit visit);

    int getCount(VisitVo visitVo);

    Visit getVisitById(String id);

    boolean updateVisit(Visit visit);
}
