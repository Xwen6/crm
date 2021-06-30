package wyu.xwen.settings.dao;

import wyu.xwen.settings.domain.DicType;

import java.util.List;

public interface DicTypeDao {
    List<DicType> getDicTypeList();

    void addDicType(DicType dicType);

    int updateDicType(DicType id);

    Object getDicTypeById(String code);

    int deleteDicType(String[] codes);
}
