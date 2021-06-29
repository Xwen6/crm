package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.dao.VisitDao;
import wyu.xwen.workbench.dao.VisitRemarkDao;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.domain.VisitRemark;
import wyu.xwen.workbench.service.VisitService;

import java.util.List;

@Service
public class VisitServiceImpl implements VisitService
{
    @Autowired
    private VisitDao visitDao;

    @Autowired
    private VisitRemarkDao visitRemarkDao;

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
    public VisitVo getVisitById(String id)
    {
        return visitDao.getVisitById(id);
    }

    @Override
    public boolean updateVisit(Visit visit)
    {
        int count = visitDao.updateVisit(visit);
        return count == 1;
    }

    @Override
    public Boolean deleteVisit(String[] ids)
    {
        int count = visitDao.deleteVisit(ids);
        return count == ids.length;
    }

    @Override
    public Boolean addRemark(VisitRemark visitRemark)
    {
        int count = visitRemarkDao.addRemark(visitRemark);
        return count == 1;
    }

    @Override
    public List<VisitRemark> getRemarkListByVisitId(String visitId)
    {
        return visitRemarkDao.getRemarkListByVisitId(visitId);
    }

    @Override
    public Boolean editRemark(VisitRemark visitRemark)
    {
        int count = visitRemarkDao.editRemark(visitRemark);
        return count == 1;
    }

    @Override
    public Boolean deleteRemark(String id)
    {
        return visitRemarkDao.deleteRemark(id);
    }
}
