package wyu.xwen.settings.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import wyu.xwen.settings.domain.DicType;
import wyu.xwen.settings.service.DicService;

import java.util.List;

@Controller
@RequestMapping("/settings/web/")
public class DictionaryController
{
    @Autowired
    private DicService dicService;

    /*查找所有的数据字典类型*/
    @RequestMapping("/getDicTypeList.do")
    @ResponseBody
    public List<DicType> getDicTypeList()
    {
        return dicService.getDicTypeList();
    }

    /*保存数据字典类型*/
    @RequestMapping("/addDicType.do")
    public String addDicType(DicType dicType)
    {
        dicService.addDicType(dicType);
        return "settings/dictionary/index";
    }

    /*修改数据字典类型*/
    @RequestMapping("/updateDicType.do")
    @ResponseBody
    public ModelAndView toDicTypeEdit(DicType dicType)
    {
        boolean flag = dicService.updateDicType(dicType);
        String message = "修改失败";
        ModelAndView modelAndView = new ModelAndView();
        if (flag)
        {
            message = "修改成功";
        }
        modelAndView.addObject("flag",flag);
        modelAndView.addObject("message",message);
        modelAndView.setViewName("settings/dictionary/type/index");
        return modelAndView;
    }

    /*删除数据字典*/
    @RequestMapping("/deleteDicType.do")
    @ResponseBody
    public Boolean deleteDicType(String[] codes)
    {
        return dicService.deleteDicType(codes);
    }
}
