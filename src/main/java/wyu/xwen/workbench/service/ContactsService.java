package wyu.xwen.workbench.service;

import wyu.xwen.exception.ContactsDeleteException;
import wyu.xwen.vo.PageVo;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.Contacts;
import wyu.xwen.workbench.domain.ContactsRemark;
import wyu.xwen.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsService
{
    List<Contacts> getContactsList();

    List<Contacts> getContactsListByName(String name);

    PageVo pageList(Map<String, Object> map);

    Contacts getContactsById(String id);

    boolean updateContacts(Contacts contacts);

    boolean deleteContacts(String[] ids) throws ContactsDeleteException;

    List<ContactsRemark> getRemarkByCId(String contactsId);

    boolean updateRemark(ContactsRemark remark);

    boolean deleteRemark(String id);

    boolean saveRemark(ContactsRemark remark);

    List<Tran> getTranList(String contactsId);

    boolean deleteTran(String tranId);

    List<Activity> getActivityListByCId(String contactsId);

    boolean relieveRelation(String id);

    List<Activity> getActivityList(String name, String contactsId);

    boolean saveRelation(String[] activityIds, String contactsId);
}
