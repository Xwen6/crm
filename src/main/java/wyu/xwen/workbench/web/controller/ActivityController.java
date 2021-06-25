package wyu.xwen.workbench.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.ActivityVo;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.service.ActivityService;

import javax.servlet.http.HttpServletRequest;
import java.net.http.HttpRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
    @RequestMapping("/PageList.do")
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
    @RequestMapping(value = "/getUserList.do",method = RequestMethod.GET)
    @ResponseBody
    public List<User> getUserList(){
      return activityService.getUserList();
    }

    /*保存市场活动*/
    @RequestMapping(value = "/ActivitySave.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Boolean> ActivitySave(Activity activity, HttpServletRequest request){

        /*owner" : $.trim($("#create-owner").val()),
					"name" :  $.trim($("#create-name").val()),
					"startDate" :  $.trim($("#create-startDate").val()),
					"endDate" :  $.trim($("#create-endDate").val()),
					"cost" :  $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val()),*/

        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        Boolean success =  activityService.saveActivity(activity);
        System.out.println(success);
        Map<String,Boolean> map = new HashMap<>();
        map.put("success",success);
        return map;
    }

    /*更新市场活动时的数据填充*/
    @RequestMapping("/getActivityById.do")
    @ResponseBody
    public Activity getActivityById(String id){
        /*System.out.println(activityService.getActivityById(id));*/
        Activity activity = activityService.getActivityById(id);
        System.out.println(activity);
        return activity;
    }

    /*执行修改*/
    @RequestMapping("Update.do")
    @ResponseBody
    public Object Update(Activity activity){
       Boolean success =  activityService.doUpdate(activity);
        return PringFlag.printnFlag(success);
    }

}
