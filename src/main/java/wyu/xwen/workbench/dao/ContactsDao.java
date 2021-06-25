package wyu.xwen.workbench.dao;

import org.apache.ibatis.annotations.Param;
import wyu.xwen.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao
{
    List<Contacts> getContactsList();

    List<Contacts> getContactsListByName(@Param("name") String name);
}
