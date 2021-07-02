package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {
    int saveRelation(ContactsActivityRelation contactsActivityRelation);

    int relieveRelation(String id);

    int relieveRelationByContactsId(String id);
}
