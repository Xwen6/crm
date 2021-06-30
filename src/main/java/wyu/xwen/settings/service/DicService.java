package wyu.xwen.settings.service;

import wyu.xwen.settings.domain.DicType;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, Object> getDic();

    List<DicType> getDicTypeList();

    void addDicType(DicType dicType);

    boolean updateDicType(DicType dicType);

    Object getDicTypeById(String code);

    boolean deleteDicType(String[] codes);
}
