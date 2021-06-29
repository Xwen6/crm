package wyu.xwen.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.settings.service.UserService;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.domain.Visit;
import wyu.xwen.workbench.service.VisitService;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/web/system")
public class systemController {

    @Autowired
    private UserService userService;

    @Autowired
    private VisitService visitService;

    /*跳转到登录页面*/
    @RequestMapping("toLogin.do")
    public String toLogin(){
        return "login";
    }

    /*跳转到工作台首页*/
    @RequestMapping("toWorkBench.do")
    public  String toWorkBench(){return "workbench/index";}

    /*跳转到activity*/
    @RequestMapping("toActivity.do")
    public  String toActivity(){return "workbench/activity/index";}

    /*workbench/clue/index*/
    @RequestMapping("toClue.do")
    public  String toClue(){return "workbench/clue/index";}

    /*workbench/customer/index.jsp*/
    @RequestMapping("toCustomer.do")
    public  String toCustomer(){return "workbench/customer/index";}

    /*workbench/contacts/index.jsp*/
    @RequestMapping("toContacts.do")
    public  String Contacts(){return "workbench/contacts/index";}

    /*workbench/transaction/index.jsp*/
    @RequestMapping("toTransaction.do")
    public  String toTransaction(){return "workbench/transaction/index";}

    /*workbench/visit/index.jsp*/
    @RequestMapping("toVisit.do")
    public ModelAndView toVisit(HttpServletRequest request) throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
        modelAndView.addObject("user",request.getSession().getAttribute("user"));
        modelAndView.setViewName("workbench/visit/index");
        return modelAndView;
    }
    /*跳转到回访详细页面*/
    @RequestMapping("toVisitDetail.do")
    public ModelAndView toVisitDetail(String id)
    {
        ModelAndView modelAndView = new ModelAndView();
        VisitVo visitVo = visitService.getVisitById(id);
        visitVo.setCreateName(userService.getUserNameById(visitVo.getCreateBy()));
        if (visitVo.getEditBy() != null)
        {
            visitVo.setEditName(userService.getUserNameById(visitVo.getEditBy()));
        }
        modelAndView.addObject("visitVo",visitVo);
        modelAndView.setViewName("workbench/visit/detail");
        return modelAndView;
    }
    /*跳转到回访添加页面*/
    @RequestMapping("toVisitSaveTask.do")
    public ModelAndView toVisitSaveTask(HttpServletRequest request) throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
        modelAndView.addObject("user",request.getSession().getAttribute("user"));
        modelAndView.setViewName("workbench/visit/saveTask");
        return modelAndView;
    }

    /*跳转到编辑页面*/
    @RequestMapping("toVisitEditTask.do")
    public ModelAndView toVisitEditTask(String id,HttpServletRequest request) throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        VisitVo visitVo = visitService.getVisitById(id);
        modelAndView.addObject("visit",visitVo);
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
        modelAndView.addObject("user",request.getSession().getAttribute("user"));
        modelAndView.setViewName("workbench/visit/editTask");
        return modelAndView;
    }
}
