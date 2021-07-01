package wyu.xwen.settings.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyu.xwen.settings.dao.DepartmentDao;
import wyu.xwen.settings.domain.Department;
import wyu.xwen.settings.service.DepartmentService;

import java.util.List;

@Service
public class DepartmentServiceImpl implements DepartmentService
{
    @Autowired
    private DepartmentDao departmentDao;

    @Override
    public List<Department> pageList(Department department)
    {
        return departmentDao.pageList(department);
    }

    @Override
    public int getCount(Department department)
    {
        return departmentDao.getCount(department);
    }

    @Override
    public Boolean addDepartment(Department department)
    {
        int count = departmentDao.addDepartment(department);
        return count == 1;
    }

    @Override
    public Department getDeptById(String id)
    {
        return departmentDao.getDeptById(id);
    }

    @Override
    public Boolean updateDepartment(Department department)
    {
        int count = departmentDao.updateDepartment(department);
        return count == 1;
    }

    @Override
    public Boolean deleteDepartment(String[] ids)
    {
        int count = departmentDao.deleteDepartment(ids);
        return count == ids.length;
    }
}
