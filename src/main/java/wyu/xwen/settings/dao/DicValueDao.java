package wyu.xwen.settings.dao;

import wyu.xwen.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getDicValueByTypeCode(String typeCode);

    List<DicValue> getDicValueList();

    void addDicValue(DicValue dicValue);

    DicValue getDicValueById(String id);

    int editDicValue(DicValue dicValue);

    int deleteDicValue(String[] ids);
}
