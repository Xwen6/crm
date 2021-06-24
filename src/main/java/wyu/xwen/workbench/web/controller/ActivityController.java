package wyu.xwen.workbench.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.settings.domain.User;
import wyu.xwen.vo.ActivityVo;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private ActivityService activityService;

    @RequestMapping(value = "/selectRemarkListByAid.do",method = RequestMethod.GET)
    public List<Activity> selectRemarkListByAid(String activityId){
        return null;
    }

    /*获取市场活动数据*/
    @RequestMapping("PageList.do")
    @ResponseBody
    public PageVo pageList(ActivityVo activityVo){
        int pageNo = Integer.parseInt(activityVo.getPageNo());
        int pageSize = Integer.parseInt(activityVo.getPageSize());
        int skinPage = (pageNo-1)*pageSize;
        /*map封装查询条件*/
        Map<String,Object> map = new HashMap<>();
        map.put("name",activityVo.getName());
        map.put("owner",activityVo.getOwner());
        map.put("startDate",activityVo.getStartDate());
        map.put("endDate",activityVo.getEndDate());
        map.put("skinPage",skinPage);
        map.put("pageSize",pageSize);
        /*返回*/
        return activityService.pageList(map);
    }

    /*获取用户列表*/
    @RequestMapping("getUserList.do")
    public List<User> getUserList(){
      return activityService.getUserList();
    }

}
