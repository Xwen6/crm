package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.settings.domain.User;
import wyu.xwen.settings.service.UserService;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.domain.VisitRemark;
import wyu.xwen.workbench.service.ContactsService;
import wyu.xwen.workbench.service.VisitService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/visit")
public class VisitController
{
    @Autowired
    private VisitService visitService;

    @Autowired
    private UserService userService;

    @Autowired
    private ContactsService contactsService;

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
        String message = "修改失败";
        modelAndView.addObject("flag",flag);
        if (flag)
        {
            message = "修改成功";
        }
        modelAndView.addObject("message",message);
        modelAndView.setViewName("/workbench/visit/index");
        return modelAndView;
    }

    @RequestMapping("/deleteVisit.do")
    @ResponseBody
    public Boolean deleteVisit(String[] ids)
    {
        return visitService.deleteVisit(ids);
    }

    @RequestMapping("/addRemark.do")
    @ResponseBody
    public Boolean addRemark(VisitRemark visitRemark)
    {
        visitRemark.setId(UUIDUtil.getUUID());
        visitRemark.setCreateTime(DateTimeUtil.getSysTime());
        visitRemark.setEditFlag("0");
        return visitService.addRemark(visitRemark);
    }

    @RequestMapping("/getRemarkList.do")
    @ResponseBody
    public List<VisitRemark> getRemarkListByVisitId(String visitId)
    {
        List<VisitRemark> list = visitService.getRemarkListByVisitId(visitId);
        for (VisitRemark visitRemark:list)
        {
            if (visitRemark.getEditBy() != null)
            {
                visitRemark.setEditBy(userService.getUserNameById(visitRemark.getEditBy()));
            }
        }
        return list;
    }

    @RequestMapping("/editRemark.do")
    @ResponseBody
    public Boolean editRemark(VisitRemark visitRemark)
    {
        visitRemark.setEditTime(DateTimeUtil.getSysTime());
        return visitService.editRemark(visitRemark);
    }

    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public Boolean deleteRemark(String id)
    {
        return visitService.deleteRemark(id);
    }

    @RequestMapping("/detailDeleteVisit.do")
    public ModelAndView detailDeleteVisit(String[] id)
    {
        ModelAndView modelAndView = new ModelAndView();
        boolean flag = visitService.deleteVisit(id);
        modelAndView.addObject("flag",flag);
        String message = "删除失败";
        if (flag)
        {
            message = "删除成功";
        }
        modelAndView.addObject("message",message);
        modelAndView.setViewName("/workbench/visit/index");
        return modelAndView;
    }
}
