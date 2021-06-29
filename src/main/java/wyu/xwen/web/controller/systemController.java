package wyu.xwen.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.SelectUserListException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.settings.service.UserService;
import wyu.xwen.utils.MD5Util;
import wyu.xwen.vo.VisitVo;
import wyu.xwen.workbench.service.VisitService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public ModelAndView toWorkBench(HttpServletRequest request)
    {
        User user = (User) request.getSession().getAttribute("user");
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("user",user);
        modelAndView.setViewName("workbench/index");
        return modelAndView;
    }

    /*退出登录*/
    @RequestMapping("logout.do")
    public String logout(HttpServletRequest request)
    {
        request.getSession().removeAttribute("user");
        return "login";
    }

    /*更新密码*/
    @RequestMapping("updatePassword.do")
    @ResponseBody
    public Map<String,Object> updatePassword(String oldPwd, String newPwd,HttpServletRequest request)
    {
        oldPwd = MD5Util.getMD5(oldPwd);
        newPwd = MD5Util.getMD5(newPwd);
        Map<String,Object> map = new HashMap<>();
        boolean flag = false;
        User user = (User) request.getSession().getAttribute("user");
        String id = user.getId();
        if (!user.getLoginPwd().equals(oldPwd))
        {
            map.put("flag",flag);
            map.put("message","旧密码错误！");
            return map;
        }
        if (user.getLoginPwd().equals(newPwd))
        {
            map.put("flag",flag);
            map.put("message","新密码与旧密码不能一致！");
            return map;
        }
        flag = userService.updatePassword(id,newPwd);
        map.put("flag",flag);
        map.put("message","修改成功");
        return map;
    }

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
    public ModelAndView toVisit() throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
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
    public ModelAndView toVisitSaveTask() throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
        modelAndView.setViewName("workbench/visit/saveTask");
        return modelAndView;
    }

    /*跳转到编辑页面*/
    @RequestMapping("toVisitEditTask.do")
    public ModelAndView toVisitEditTask(String id) throws SelectUserListException
    {
        ModelAndView modelAndView = new ModelAndView();
        VisitVo visitVo = visitService.getVisitById(id);
        modelAndView.addObject("visit",visitVo);
        List<User> list = userService.selectUserList();
        modelAndView.addObject("list",list);
        modelAndView.setViewName("workbench/visit/editTask");
        return modelAndView;
    }
}
