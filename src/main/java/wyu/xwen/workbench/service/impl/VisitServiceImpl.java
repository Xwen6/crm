package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.workbench.dao.VisitDao;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.service.VisitService;

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
}
