package wyu.xwen.workbench.dao;

import org.apache.ibatis.annotations.Param;
import wyu.xwen.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao
{
    List<Contacts> getContactsList();

    List<Contacts> getContactsListByName(@Param("name") String name);

    int saveContacts(Contacts contacts);

    List<Contacts> getContactsListByCId(String customerId);

    int deleteContacts(String id);

    int saveContacts2(Contacts contacts);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByCondition(Map<String, Object> map);

    Contacts getContactsListById(String id);

    boolean updateContacts(Contacts contacts);
}
