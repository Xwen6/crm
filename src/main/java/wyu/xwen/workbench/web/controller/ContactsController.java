package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.service.ContactsService;

import java.util.List;

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
}
