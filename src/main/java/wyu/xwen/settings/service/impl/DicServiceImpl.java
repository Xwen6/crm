package wyu.xwen.settings.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.settings.dao.DicTypeDao;
import wyu.xwen.settings.dao.DicValueDao;
import wyu.xwen.settings.domain.DicType;
import wyu.xwen.settings.domain.DicValue;
import wyu.xwen.settings.service.DicService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {

    @Autowired
    private DicTypeDao dicTypeDao;
    @Autowired
    private DicValueDao dicValueDao;

    @Override
    public Map<String, Object> getDic() {
        Map<String,Object> dicMap = new HashMap<>();
        /*首先获取字典类型列表*/
        List<DicType> dicTypes = dicTypeDao.getDicTypeList();
        for (DicType type:dicTypes
             ) {
            /*根据类型取得value列表*/
          String typeCode =  type.getCode();
          List<DicValue> dicValueList = dicValueDao.getDicValueByTypeCode(typeCode);
          dicMap.put(typeCode,dicValueList);
        }

        return dicMap;
    }
}
