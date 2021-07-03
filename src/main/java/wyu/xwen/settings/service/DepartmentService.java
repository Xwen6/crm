package wyu.xwen.settings.service;

import wyu.xwen.settings.domain.Department;

import java.util.List;

public interface DepartmentService
{
    List<Department> pageList(Department department);

    int getCount(Department department);

    Boolean addDepartment(Department department);

    Department getDeptById(String id);

    Boolean updateDepartment(Department department);

    Boolean deleteDepartment(String[] ids);

    String getDeptIdByName(String deptName);
}
