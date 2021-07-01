package wyu.xwen.settings.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import wyu.xwen.settings.domain.Department;
import wyu.xwen.settings.service.DepartmentService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/settings/department")
@Controller
public class DepartmentController
{
    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/pageList.do")
    @ResponseBody
    public Map<String,Object> pageList(Department department)
    {
        Integer skinPage = (department.getPageNo() - 1) * department.getPageSize();
        department.setSkipPage(skinPage);
        List<Department> list = departmentService.pageList(department);
        int count = departmentService.getCount(department);
        Map<String,Object> map = new HashMap<>();
        map.put("list",list);
        map.put("total",count);
        return map;
    }

    /*添加部门*/
    @RequestMapping("/addDepartment.do")
    @ResponseBody
    public Boolean addDepartment(Department department)
    {
        return departmentService.addDepartment(department);
    }

    /*获取部门*/
    @RequestMapping("/getDeptById.do")
    @ResponseBody
    public Department getDeptById(String id)
    {
        return departmentService.getDeptById(id);
    }

    /*编辑*/
    @RequestMapping("updateDepartment.do")
    @ResponseBody
    public Boolean updateDepartment(Department department)
    {
        return departmentService.updateDepartment(department);
    }

    /*删除*/
    @RequestMapping("deleteDepartment.do")
    @ResponseBody
    public Boolean deleteDepartment(String[] ids)
    {
        return departmentService.deleteDepartment(ids);
    }
}
