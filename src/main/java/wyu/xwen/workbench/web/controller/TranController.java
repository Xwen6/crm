package wyu.xwen.workbench.web.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.exception.TranDeleteException;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.ChartVO2;
import wyu.xwen.vo.ChartVo;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.dao.CustomerDao;
import wyu.xwen.workbench.domain.*;
import wyu.xwen.workbench.service.TranService;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {
    @Autowired
    TranService tranService;


    /*pageList
    *workbench/transaction/pageList.do
    */
    @RequestMapping("pageList.do")
    @ResponseBody
    public Object pageList(Tran tran){
        int pageNo = tran.getPageNo();
        int pageSize = tran.getPageSize();
        int skinPage = (pageNo - 1) * pageSize;
        tran.setSkinPage(skinPage);
        return tranService.pageList(tran);
    }

    /*模糊查询
    workbench/transaction/getCustomerName.do*
     */
    @RequestMapping("getCustomerName.do")
    @ResponseBody
    public List<Customer> getCustomerByName(String name){
        return tranService.getCustomerByName(name);
    }

    /*查找联系人
    * workbench/transaction/getContactsList.do
    * */

    @RequestMapping("getContactsList.do")
    @ResponseBody
    public List<Contacts> getContacts(String fullname){

        return tranService.getContactsByName(fullname);
    }

    /*新增交易
    * workbench/transaction/saveTran.do
    * */
    @RequestMapping("saveTran.do")
    public String saveTran(Tran tran, HttpServletRequest request){
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setCreateBy(((User)(request.getSession().getAttribute("user"))).getName());
        boolean success = tranService.saveTran(tran);

        return "workbench/transaction/index";
    }

    /*删除交易
     *workbench/transaction/deleteTran.do
     */
    @RequestMapping("deleteTran.do")
    @ResponseBody
    public Object deleteTran(String ids[]) throws TranDeleteException {
        boolean success = tranService.deleteTran(ids);
        return PringFlag.printnFlag(success);
    }

    /*workbench/transaction/toEditTran*/
    @RequestMapping("toEditTran.do")
    public ModelAndView toEditTran(String id){
        ModelAndView modelAndView = new ModelAndView();
        Tran tran = tranService.getTranById(id);
        List<User> userList = tranService.getUserList();
        modelAndView.addObject("userList",userList);
        modelAndView.addObject("tran",tran);
        modelAndView.setViewName("workbench/transaction/edit");
        return modelAndView;
    }

    /*更新
    * workbench/transaction/updateTran.do
    * */
    @RequestMapping("updateTran.do")
    public ModelAndView updateTran(Tran tran,HttpServletRequest request){
        tran.setEditBy(((User)(request.getSession().getAttribute("user"))).getName());
        tran.setCreateBy(tran.getEditBy());
        tran.setEditBy(DateTimeUtil.getSysTime());
        Tran tran1 = tranService.updateTran(tran);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran1.getStage());
        tran1.setPossibility(possibility);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tran",tran1);
        modelAndView.setViewName("workbench/transaction/detail");
        return modelAndView;
    }

    /*workbench/transaction/detail.do*/
    @RequestMapping("detail.do")
    public ModelAndView detail(String id,HttpServletRequest request){
        ModelAndView modelAndView = new ModelAndView();
        Tran tran = tranService.detail(id);
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);
        modelAndView.addObject("tran",tran);
        modelAndView.setViewName("workbench/transaction/detail");
        return modelAndView;
    }

    /*workbench/transaction/changeStage.do*/
    @RequestMapping("changeStage.do")
    @ResponseBody
    public Object ChangeStage(Tran tran,HttpServletRequest request){
        tran.setEditTime(DateTimeUtil.getSysTime());
        tran.setEditBy(((User)(request.getSession().getAttribute("user"))).getName());
        boolean success =  tranService.changeStage(tran);

        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("tran",tran);
        resultMap.put("success",success);
        return resultMap;
    }

    /*workbench/transaction/getTranHistoryList.do*/
    @RequestMapping("getTranHistoryList.do")
    @ResponseBody
    public Object getTranHistory(String tranId,HttpServletRequest request){
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        List<TranHistory> tranHistories =  tranService.getTranHistory(tranId);
        for (TranHistory history:tranHistories
             ) {
            String possibility = pMap.get(history.getStage());
            history.setPossibility(possibility);
        }
       return tranHistories;
    }

    /*workbench/transaction/getRemarkListByTid.do*/
    @RequestMapping("getRemarkListByTid.do")
    @ResponseBody
    public List<TranRemark> getTranRemarks(String tranId){
        return tranService.getTranRemarks(tranId);
    }

    /*workbench/transaction/remarkUpdate.do*/
    @RequestMapping("remarkUpdate.do")
    @ResponseBody
    public Object UpdateRemark(TranRemark remark){
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("1");
        boolean success = tranService.updateRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*workbench/transaction/deleteRemark.do*/
    @RequestMapping("deleteRemark.do")
    @ResponseBody
    public Object deleteRemark(String id){
        boolean success = tranService.deleteRemark(id);
        return  PringFlag.printnFlag(success);
    }

    /*workbench/transaction/saveRemark.do*/
    @RequestMapping("saveRemark.do")
    @ResponseBody
    public Object saveRemark(TranRemark remark){
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("0");
        remark.setId(UUIDUtil.getUUID());
        boolean success = tranService.saveRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*workbench/transaction/deleteTranInDetail.do*/
    @RequestMapping("deleteTranInDetail.do")
    public Object deleteTranInDetail(String[] id) throws TranDeleteException {
       boolean success =  tranService.deleteTran(id);
        return PringFlag.printnFlag(success);
    }

    /*workbench/transaction/chart1*/

    @RequestMapping("chart1.do")
    @ResponseBody
    public Object getCharData(){
        List<ChartVo> data = tranService.getCharData();
        Map<String,Object> map = new HashMap<>();
        List<String> countKey = new ArrayList<>();
        List<String> countValue = new ArrayList<>();
        for (ChartVo chartVo:data
             ) {
           countKey.add(chartVo.getCountKey());
           countValue.add(chartVo.getCountValue());
        }
        map.put("countKey",countKey);
        map.put("countValue",countValue);
        return map;
    }

    /*workbench/transaction/chart2.do*/
    @RequestMapping("chart2.do")
    @ResponseBody
    public  List<ChartVO2> chart2(){
        return tranService.getCharData2();
    }

    /*workbench/transaction/chart3.do*/
    @RequestMapping("chart3.do")
    @ResponseBody
    public Map<String,Object> chart3(){
        List<ChartVo> data = tranService.getCharData3();
        Map<String,Object> map = new HashMap<>();
        List<String> countKey = new ArrayList<>();
        List<String> countValue = new ArrayList<>();
        for (ChartVo chartVo:data
        ) {
            countKey.add(chartVo.getCountKey());
            countValue.add(chartVo.getCountValue());
        }
        map.put("countKey",countKey);
        map.put("countValue",countValue);
        return map;
    }

    /*"workbench/transaction/chart4.do"*/
    @RequestMapping("chart4.do")
    @ResponseBody
    public List<ChartVO2> chart4(){
        return tranService.getCharData4();
    }
}
