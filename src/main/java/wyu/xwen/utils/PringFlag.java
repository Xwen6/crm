package wyu.xwen.utils;

import java.util.HashMap;
import java.util.Map;

public class PringFlag {
    //将boolean值解析为json串
    public static Map<String,Boolean> printnFlag(boolean flag){

        Map<String,Boolean> map = new HashMap<String,Boolean>();
        map.put("success",flag);
        return map;
    }
}
