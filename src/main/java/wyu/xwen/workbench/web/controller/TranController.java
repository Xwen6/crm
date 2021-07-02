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
import wyu.xwen.workbench.dao.CustomerDao;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.service.TranService;

import javax.servlet.http.HttpServletRequest;
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
    public String updateTran(Tran tran,HttpServletRequest request){
        tran.setEditBy(((User)(request.getSession().getAttribute("user"))).getName());
        tran.setEditBy(DateTimeUtil.getSysTime());
        boolean success = tranService.updateTran(tran);
        return "workbench/transaction/index";
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
}
