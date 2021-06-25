package wyu.xwen.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.workbench.dao.ContactsDao;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.service.ContactsService;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService
{
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public List<Contacts> getContactsList()
    {
        return contactsDao.getContactsList();
    }
}
