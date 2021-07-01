package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.settings.domain.User;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.Customer;
import wyu.xwen.workbench.domain.CustomerRemark;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.service.CustomerService;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/PageList.do")
    @ResponseBody
    public PageVo pageList(Customer customer) {
        int pageNo = Integer.parseInt(customer.getPageNo());
        int pageSize = Integer.parseInt(customer.getPageSize());
        int skinPage = (pageNo - 1) * pageSize;
        /*map封装查询条件*/
        Map<String, Object> map = new HashMap<>();
        map.put("name",customer.getName());
        map.put("owner",customer.getOwner());
        map.put("phone",customer.getPhone());
        map.put("website",customer.getWebsite());
        map.put("skinPage",skinPage);
        map.put("pageSize",pageSize);
        /*返回*/
        return customerService.pageList(map);
    }

    /*添加客户
    * workbench/customer/customerSave.do*/
    @RequestMapping("customerSave.do")
    @ResponseBody
    public Object saveCustomer(Customer customer, HttpServletRequest request){
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setCreateBy(((User)(request.getSession().getAttribute("user"))).getName());
        boolean success = customerService.saveCustomer(customer);
        return PringFlag.printnFlag(success);
    }

    /*workbench/customer/getCustomerById.do
    * 填充修改模态框数据*/
    @RequestMapping("getCustomerById.do")
    @ResponseBody
    public Customer getCustomerById(String id){
        return customerService.getCustomerById(id);
    }

    /*执行更新
    * workbench/customer/updateCustomer.do*/
    @RequestMapping("updateCustomer.do")
    @ResponseBody
    public Object updateCustomer(Customer customer){
        System.out.println(customer.getId());
        customer.setEditTime(DateTimeUtil.getSysTime());
        customer.setEditTime(DateTimeUtil.getSysTime());
        boolean success = customerService.updateCustomer(customer);
        return PringFlag.printnFlag(success);
    }

    /*删除
    *
    * workbench/Customer/deleteCustomer.do*/
    @RequestMapping("deleteCustomer.do")
    @ResponseBody
    public Object deleteCustomer(String[] id){
        boolean success = customerService.deleteCustomer(id);
        return PringFlag.printnFlag(success);
    }

    /*跳转详细信息页面
    * workbench/customer/detail.do
    * */
    @RequestMapping("detail.do")
    public ModelAndView detail(String id){
        ModelAndView modelAndView = new ModelAndView();
        Customer customer = customerService.getCustomerById(id);
        modelAndView.addObject("customer",customer);
        modelAndView.setViewName("workbench/customer/detail");
        return modelAndView;
    }

    /*获取备注列表
    * workbench/customer/getRemarkListByCid.do
    * */

    @RequestMapping("getRemarkListByCid")
    @ResponseBody
    public List<CustomerRemark> getRemarks(String customerId){

        return customerService.getRemarksByCId(customerId);
    }

    /*更新备注
    * workbench/customer/remarkUpdate.do*/
    @RequestMapping("remarkUpdate.do")
    @ResponseBody
    public Object remarkUpdate(CustomerRemark remark){
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("1");
        boolean success = customerService.updateRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*删除备注
    * workbench/customer/deleteRemark.do
    * */
    @RequestMapping("deleteRemark.do")
    @ResponseBody
    public Object deleteRemark(String id){
        boolean success = customerService.deleteRemark(id);
        return PringFlag.printnFlag(success);
    }

    /*新增备注
    *workbench/customer/saveRemark.do
     */
    @RequestMapping("saveRemark")
    @ResponseBody
    public Object saveRemark(CustomerRemark remark){
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = customerService.saveRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*查询该客户的交易
    workbench/customer/showTranList
     */
    @RequestMapping("showTranList.do")
    @ResponseBody
    public List<Tran> showTranListByCId(String customerId){
        return customerService.showTranListByCId(customerId);
    }

    /*删除交易
    * workbench/customer/deleteTran.do
    * */
    @RequestMapping("deleteTran.do")
    @ResponseBody
    public Object deleteTran(String id){
        boolean success = customerService.deleteTran(id);
        return PringFlag.printnFlag(success);
    }

    /*查找联系人
    * workbench/customer/showContactsList.do
    * */
    @RequestMapping("showContactsList.do")
    @ResponseBody
    public List<Contacts> getContactsByCId(String customerId){
        return customerService.getContactsByCId(customerId);
    }

    /*删除联系人
    * workbench/customer/deleteContacts.do
    * */
    @RequestMapping("deleteContacts.do")
    @ResponseBody
    public Object deleteContacts(String id){
        boolean success =  customerService.deleteContacts(id);
        return PringFlag.printnFlag(success);
    }

    /*自动补全，模糊查询
    * workbench/customer/getCustomerName.do
    * */
    @RequestMapping("getCustomerName.do")
    @ResponseBody
    public List<Customer> getCustomerName(String name){
        return customerService.getCustomerName(name);
    }

    /*新建联系人
    * workbench/customer/contactsSave.do
    * */
    @RequestMapping("contactsSave.do")
    @ResponseBody
    public Object contactsSave(Contacts contacts){
        System.out.println(contacts.getCustomerId());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = customerService.saveContacts(contacts);
        return PringFlag.printnFlag(success);
    }





}
