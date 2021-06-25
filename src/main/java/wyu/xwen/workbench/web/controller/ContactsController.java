package wyu.xwen.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.service.ContactsService;

import java.util.List;

@Controller
@RequestMapping("/contacts")
public class ContactsController
{
    @Autowired
    private ContactsService contactsService;

    @RequestMapping("/getContactsList.do")
    @ResponseBody
    public List<Contacts> getContactsList()
    {
        return contactsService.getContactsList();
    }
}
