package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {
    int saveContactsRemark(ContactsRemark contactsRemark);

    List<ContactsRemark> getRemarkByCId(String contactsId);


    int deleteRemark(String id);

    int updateRemark(ContactsRemark remark);
}
