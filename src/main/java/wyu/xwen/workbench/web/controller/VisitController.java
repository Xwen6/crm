package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.service.VisitService;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/visit")
public class VisitController
{
    @Autowired
    private VisitService visitService;

    @RequestMapping("/addVisit.do")
    public String addVisit(Visit visit, HttpServletRequest request)
    {
        User user = (User)request.getSession().getAttribute("user");
        visit.setId(UUIDUtil.getUUID());
        visit.setCreateTime(DateTimeUtil.getSysTime());
        visit.setCreateBy(user.getId());
        boolean flag = visitService.addVisit(visit);
        return "workbench/visit/index";
    }
}
