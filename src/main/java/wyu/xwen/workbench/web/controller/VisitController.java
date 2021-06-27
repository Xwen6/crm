package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.service.VisitService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/visit")
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

    @RequestMapping("/getVisitLisit.do")
    @ResponseBody
    public List<Visit> getVisitList()
    {
        return visitService.getVisitList();
    }

    @RequestMapping("/PageList.do")
    @ResponseBody
    public Map<String,Object> PageList(VisitVo visitVo)
    {
        Integer skinPage = (visitVo.getPageNo() - 1) * visitVo.getPageSize();
        visitVo.setSkipPage(skinPage);
        List<Visit> list = visitService.PageList(visitVo);
        int count = visitService.getCount(visitVo);
        Map<String,Object> map = new HashMap<>();
        map.put("list",list);
        map.put("total",count);
        return map;
    }

    @RequestMapping("/updateVisit.do")
    public ModelAndView updateVisit(Visit visit)
    {
        ModelAndView modelAndView = new ModelAndView();
        visit.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = visitService.updateVisit(visit);
        String message = "添加失败";
        modelAndView.addObject("flag",flag);
        if (flag)
        {
            message = "添加成功";
        }
        modelAndView.addObject("message",message);
        modelAndView.setViewName("/workbench/visit/index");
        return modelAndView;
    }
}
