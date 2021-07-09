package wyu.xwen.workbench.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.ActivityDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.ActivityVo;
import wyu.xwen.vo.ChartVO2;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.ActivityRemark;
import wyu.xwen.workbench.service.ActivityService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private ActivityService activityService;


    /*获取市场活动数据*/
    @RequestMapping("/PageList.do")
    @ResponseBody
    public PageVo pageList(ActivityVo activityVo) {
        int pageNo = Integer.parseInt(activityVo.getPageNo());
        int pageSize = Integer.parseInt(activityVo.getPageSize());
        int skinPage = (pageNo - 1) * pageSize;
        /*map封装查询条件*/
        Map<String, Object> map = new HashMap<>();
        map.put("name", activityVo.getName());
        map.put("owner", activityVo.getOwner());
        map.put("startDate", activityVo.getStartDate());
        map.put("endDate", activityVo.getEndDate());
        map.put("skinPage", skinPage);
        map.put("pageSize", pageSize);
        /*返回*/
        return activityService.pageList(map);
    }

    /*获取用户列表*/
    @RequestMapping(value = "/getUserList.do", method = RequestMethod.GET)
    @ResponseBody
    public List<User> getUserList() {
        return activityService.getUserList();
    }

    /*保存市场活动*/
    @RequestMapping(value = "/ActivitySave.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Boolean> ActivitySave(Activity activity, HttpServletRequest request) {

        /*owner" : $.trim($("#create-owner").val()),
					"name" :  $.trim($("#create-name").val()),
					"startDate" :  $.trim($("#create-startDate").val()),
					"endDate" :  $.trim($("#create-endDate").val()),
					"cost" :  $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val()),*/

        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        Boolean success = activityService.saveActivity(activity);
        System.out.println(success);
        Map<String, Boolean> map = new HashMap<>();
        map.put("success", success);
        return map;
    }

    /*更新市场活动时的数据填充*/
    @RequestMapping("/getActivityById.do")
    @ResponseBody
    public Activity getActivityById(String id) {
        /*System.out.println(activityService.getActivityById(id));*/
        Activity activity = activityService.getActivityById(id);
        System.out.println(activity);
        return activity;
    }

    /*执行修改*/
    @RequestMapping("Update.do")
    @ResponseBody
    public Object Update(Activity activity) {
        Boolean success = activityService.doUpdate(activity);
        return PringFlag.printnFlag(success);
    }

    /*s删除市场活动*/
    @RequestMapping("/Delete.do")
    @ResponseBody
    public Object delete(HttpServletRequest request) throws ActivityDeleteException {
       String[] id =  request.getParameterValues("id");
        System.out.println(id.length);
      Boolean success =  activityService.deleteActivity(id);
      return PringFlag.printnFlag(success);
    }

    /*跳转到详细信息页面*/
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.getActivityById(id);
        mv.addObject("activity",activity);
        mv.setViewName("workbench/activity/detail");
        return mv;
    }

    /*获取市场活动备注列表*/
    @RequestMapping("/getRemarkListByAid.do")
    @ResponseBody
    public List<ActivityRemark> getRemarkListByAid(String activityId){
      return activityService.getRemarkByAid(activityId);
    }

    /*修改备注*/
    @RequestMapping("/remarkUpdate.do")
    @ResponseBody
    public Object remarkUpdate(ActivityRemark activityRemark){
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        Boolean success = activityService.updateRemark(activityRemark);
        return PringFlag.printnFlag(success);
    }

    /*删除市场活动*/
    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public Object deleteRemark(String id){
        Boolean success = activityService.deleteRemark(id);
        return PringFlag.printnFlag(true);
    }

    /*新增备注*/
    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Object saveRemark(ActivityRemark activityRemark,HttpServletRequest request){
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setEditFlag("0");
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        Boolean success = activityService.saveRemark(activityRemark);
        return PringFlag.printnFlag(success);
    }
    /*workbench/activity/chart.do*/
    @RequestMapping("chart.do")
    @ResponseBody
    public Object chart(){
        List<ChartVO2> resList = activityService.chart();
        return resList;
    }


}
