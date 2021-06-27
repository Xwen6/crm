package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.dao.VisitDao;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.service.VisitService;

import java.util.List;

@Service
public class VisitServiceImpl implements VisitService
{
    @Autowired
    private VisitDao visitDao;

    @Override
    public boolean addVisit(Visit visit)
    {
        int count = visitDao.addVisit(visit);
        return count == 1;
    }

    @Override
    public List<Visit> getVisitList()
    {
        return visitDao.getVisitList();
    }

    @Override
    public List<Visit> PageList(Visit visit)
    {
        return visitDao.PageList(visit);
    }

    @Override
    public int getCount(VisitVo visitVo)
    {
        return visitDao.getTotalByCondition(visitVo);
    }

    @Override
    public Visit getVisitById(String id)
    {
        return visitDao.getVisitById(id);
    }
}
