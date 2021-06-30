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

    @Override
    public List<DicType> getDicTypeList()
    {
        return dicTypeDao.getDicTypeList();
    }

    @Override
    public void addDicType(DicType dicType)
    {
        dicTypeDao.addDicType(dicType);
    }

    @Override
    public boolean updateDicType(DicType dicType)
    {
        int count = dicTypeDao.updateDicType(dicType);
        return count == 1;
    }

    @Override
    public Object getDicTypeById(String code)
    {
        return dicTypeDao.getDicTypeById(code);
    }

    @Override
    public boolean deleteDicType(String[] codes)
    {
        int count = dicTypeDao.deleteDicType(codes);
        return count == codes.length;
    }
}
