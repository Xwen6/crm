package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.utils.DateTimeUtil;
import wyu.xwen.utils.PringFlag;
import wyu.xwen.utils.UUIDUtil;
import wyu.xwen.vo.ContactsVo;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.ContactsRemark;
import wyu.xwen.workbench.domain.Tran;
import wyu.xwen.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController
{
    @Autowired
    private ContactsService contactsService;

    /*获取联系人对象*/
    @RequestMapping("/getContactsList.do")
    @ResponseBody
    public List<Contacts> getContactsList()
    {
        return contactsService.getContactsList();
    }
    /*模态窗口自动填充获取联系人名字*/
    @RequestMapping("/getContactsListByName.do")
    @ResponseBody
    public List<Contacts> getContactsListByName(String name)
    {
        return contactsService.getContactsListByName(name);
    }

    /*联系人页面的填充
    * workbench/contacts/PageList.do
    * */

    @RequestMapping("PageList.do")
    @ResponseBody
    public Object pageList(ContactsVo contactsVo){
        int pageNo = Integer.parseInt( contactsVo.getPageNo());
        int pageSize = Integer.parseInt(contactsVo.getPageSize());
        int skinPage = (pageNo - 1) * pageSize;
        /*map封装查询条件*/
        Map<String, Object> map = new HashMap<>();
        map.put("fullname",contactsVo.getFullname());
        map.put("owner",contactsVo.getOwner());
        map.put("customerName",contactsVo.getCustomerName() );
        map.put("source",contactsVo.getSource());
        map.put("birth",contactsVo.getBirth());
        map.put("skinPage", skinPage);
        map.put("pageSize", pageSize);

        return  contactsService.pageList(map);
    }

    /*修改填充
    * workbench/contacts/getContactsById.do
    * */
    @RequestMapping("getContactsById.do")
    @ResponseBody
    public Contacts getContactsById(String id){
        return contactsService.getContactsById(id);
    }

    /*workbench/contacts/updateContacts.do执行更新*/
    @RequestMapping("updateContacts.do")
    @ResponseBody
    public Object updateContacts(Contacts contacts){
        contacts.setEditTime(DateTimeUtil.getSysTime());
        boolean success = contactsService.updateContacts(contacts);
        return PringFlag.printnFlag(success);
    }

    /*删除
    * workbench/contacts/deleteContacts.do
    * */
    @RequestMapping("deleteContacts.do")
    @ResponseBody
    public Object deleteContacts(String[] ids){
        boolean success = contactsService.deleteContacts(ids);
        return PringFlag.printnFlag(success);
    }

    /*workbench/contacts/detail.do*/
    @RequestMapping("detail.do")
    public ModelAndView detail(String id){
        ModelAndView modelAndView = new ModelAndView();
        Contacts contacts = contactsService.getContactsById(id);
        modelAndView.addObject("contacts",contacts);
        modelAndView.setViewName("workbench/contacts/detail");
        return modelAndView;
    }

    /*
    * 查找备注列表
    * workbench/contacts/getRemarkListByCid.do
    * */
    @RequestMapping("getRemarkListByCid.do")
    @ResponseBody
    public List<ContactsRemark> getRemarkList(String contactsId){
        return contactsService.getRemarkByCId(contactsId);
    }

    /*修改备注
    * workbench/contacts/remarkUpdate.do
    * */
    @RequestMapping("remarkUpdate.do")
    @ResponseBody
    public Object updateRemark(ContactsRemark remark){
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("1");
        boolean success = contactsService.updateRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*删除备注
    * workbench/contacts/deleteRemark.do
    * */
    @RequestMapping("deleteRemark.do")
    @ResponseBody
    public Object deleteRemark(String id){
        boolean success = contactsService.deleteRemark(id);
        return PringFlag.printnFlag(success);
    }

    /*新增备注
    * workbench/contacts/saveRemark.do
    * */
    @RequestMapping("saveRemark.do")
    @ResponseBody
    public Object saveRemark(ContactsRemark remark){
        remark.setId(UUIDUtil.getUUID());
        remark.setEditFlag("0");
        remark.setCreateTime(DateTimeUtil.getSysTime());
        boolean success = contactsService.saveRemark(remark);
        return PringFlag.printnFlag(success);
    }

    /*获取交易列表
    * workbench/contacts/showTranList.do
    * */
    @RequestMapping("showTranList.do")
    @ResponseBody
    public List<Tran> getTranList(String contactsId){
        return contactsService.getTranList(contactsId);
    }

    /*删除交易
    *workbench/contacts/deleteTran.do
     */
    @RequestMapping("deleteTran.do")
    @ResponseBody
    public Object deleteTran(String id){
        boolean success = contactsService.deleteTran(id);
        return PringFlag.printnFlag(success);
    }





}
