package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.ActivityDeleteException;
import wyu.xwen.exception.CLueConvertException;
import wyu.xwen.exception.ClueDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.ClueVo;
import wyu.xwen.workbench.domain.*;
import wyu.xwen.workbench.service.ClueService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
     private ClueService clueService;

     /*页面加载填充线索数据*/
    @RequestMapping("cluePageList.do")
    @ResponseBody
    public Object getClueList(ClueVo clueVo){


        int pageNo = Integer.parseInt(clueVo.getPageNo());
        int pageSize = Integer.parseInt(clueVo.getPageSize());
        int skinPage = (pageNo - 1) * pageSize;
        /*map封装查询条件*/
        Map<String, Object> map = new HashMap<>();
        map.put("fullname",clueVo.getFullname());
        map.put("owner",clueVo.getOwner());
        map.put("phone",clueVo.getPhone() );
        map.put("mphone",clueVo.getMphone());
        map.put("source",clueVo.getSource());
        map.put("state",clueVo.getState());
        map.put("company",clueVo.getCompany());
        map.put("skinPage", skinPage);
        map.put("pageSize", pageSize);

        return  clueService.pageList(map);
    }

    /*保存线索workbench/clue/saveClue.do*/
    @RequestMapping("saveClue.do")
    @ResponseBody
    public Object saveClue(Clue clue, HttpServletRequest request){
       clue.setId(UUIDUtil.getUUID());
       clue.setCreateTime(DateTimeUtil.getSysTime());
       clue.setCreateBy(((User)(request.getSession().getAttribute("user"))).getName());
       Boolean success = clueService.saveClue(clue);
       return PringFlag.printnFlag(success);
    }

    /*根据id获取线索*/
    @RequestMapping("getClueById.do")
    @ResponseBody
    public Clue getClueById(String id) {
      return clueService.getClueById(id);
    }

    /*修改线索
    * workbench/clue/Update.do
    * */

    @RequestMapping("Update.do")
    @ResponseBody
    public Object updateClue(Clue clue, HttpServletRequest request){
        clue.setEditTime(DateTimeUtil.getSysTime());
        clue.setEditBy(((User)(request.getSession().getAttribute("user"))).getName());
      Boolean success = clueService.updateClue(clue);

      return PringFlag.printnFlag(success);
    }

    /*删除*/
    @RequestMapping("/Delete.do")
    @ResponseBody
    public Object delete(HttpServletRequest request) throws ClueDeleteException {
        String[] id =  request.getParameterValues("id");
        System.out.println(id.length);
        Boolean success =  clueService.deleteClue(id);
        return PringFlag.printnFlag(success);
    }

    /*跳转detail页面*/
    /*跳转到详细信息页面*/
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.getClueById(id);
        mv.addObject("clue",clue);
        mv.setViewName("workbench/clue/detail");
        return mv;
    }

    /*获取线索备注列表
    * workbench/clue/getRemarkListByCid.do
    * */
    @RequestMapping("/getRemarkListByCid.do")
    @ResponseBody
    public List<ClueRemark> getRemarkListByCid(String clueId){
        return clueService.getClueRemarkByClueId(clueId);
    }

    /*更新备注
    * workbench/clue/remarkUpdate.do
    * */
    @RequestMapping("remarkUpdate.do")
    @ResponseBody
    public Object updateRemark(ClueRemark remark,HttpServletRequest request){
        remark.setEditFlag("1");
        remark.setEditTime(DateTimeUtil.getSysTime());
        Boolean success =  clueService.updateRemark(remark);
        return PringFlag.printnFlag(success);

    }

    /*删除备注
    * workbench/clue/deleteRemark.do
    * */
    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public Object deleteRemark(String id){

      Boolean success = clueService.deleteRemark(id);
      return PringFlag.printnFlag(success);
    }

    /*保存备注
    * workbench/clue/saveRemark.do*/
    @RequestMapping("saveRemark.do")
    @ResponseBody
    public Object saveRemark(ClueRemark remark,HttpServletRequest request){
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("0");
        remark.setCreateBy(((User)(request.getSession().getAttribute("user"))).getName());

        Boolean success = clueService.saveRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*线索和市场活动关联
    * workbench/clue/getActivityByClueId.do
    *  获取已和线索关联的市场活动
    * */

    @RequestMapping("/getActivityByClueId.do")
    @ResponseBody
    public List<Activity> getActivityByClueId(String clueId){

        return  clueService.getActivityByClueId(clueId);
    }

    /*解除活动关联
    * workbench/clue/relieveActivityAndClueRelation.do
    * 关联表id
    * */
    @RequestMapping("relieveActivityAndClueRelation.do")
    @ResponseBody
    public Object relieve(String id){
        Boolean success = clueService.relieve(id);
        return PringFlag.printnFlag(success);
    }

    /*workbench/clue/getActivityByClueId2.do*/
    /*获取没有和该线索关联的市场活动*/
    @RequestMapping("getActivityByClueId2.do")
    @ResponseBody
    public List<Activity> getActivityByClueId2(String name,String clueId){
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
     return clueService.notAssociated(map);
    }

    /*添加联系
    * workbench/clue/saveRelation.do
    * */
    @RequestMapping("/saveRelation.do")
    @ResponseBody
    public Object aveRelation(HttpServletRequest request){
        String[] activityId = request.getParameterValues("activityId");
        String clueId = request.getParameter("clueId");
        Boolean success =  clueService.saveRelation(activityId,clueId);
        return PringFlag.printnFlag(success);
    }

    /*转换时的市场活动源
    *
    * workbench/clue/getActivityList.do
    * */
    @RequestMapping("getActivityList.do")
    @ResponseBody
    public List<Activity> getActivityList(String name){
        return clueService.getActivityList(name);
    }

    /*线索转换
    * workbench/clue/convert.do
    * */
    @RequestMapping("convert.do")
    public String convert(String clueId, boolean flag, Tran t,HttpServletRequest request)throws CLueConvertException{
        String createBy = ((User)(request.getSession().getAttribute("user"))).getName();
        Tran tran = null;
        if (flag){
            /*完善交易的参数*/
            t.setId(UUIDUtil.getUUID());
            t.setCreateTime(DateTimeUtil.getSysTime());
            tran = t;
        }
        System.out.println(tran);
        System.out.println(flag);
        System.out.println(clueId);
        clueService.convert(clueId,tran,createBy);
        return "workbench/clue/index";
    }

    /*workbench/clue/chart.do*/
    @RequestMapping("chart.do")
    @ResponseBody
    public Object chart(){
        Map<String,Object> resMap = clueService.getChartDate();
        return resMap;
    }









}
