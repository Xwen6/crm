package wyu.xwen.settings.dao;

import wyu.xwen.settings.domain.Department;

import java.util.List;

public interface DepartmentDao
{
    List<Department> pageList(Department department);

    int getCount(Department department);

    int addDepartment(Department department);

    Department getDeptById(String id);

    int updateDepartment(Department department);

    int deleteDepartment(String[] ids);

    String getDeptIdByName(String deptName);
}
