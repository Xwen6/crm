package wyu.xwen.vo;

import wyu.xwen.settings.domain.User;

public class UserVo extends User
{
    private Integer pageNo;
    private Integer pageSize;
    private Integer skipPage;
    private String createName;
    private String editName;

    public String getCreateName()
    {
        return createName;
    }

    public void setCreateName(String createName)
    {
        this.createName = createName;
    }

    public String getEditName()
    {
        return editName;
    }

    public void setEditName(String editName)
    {
        this.editName = editName;
    }

    public Integer getSkipPage()
    {
        return skipPage;
    }

    public void setSkipPage(Integer skipPage)
    {
        this.skipPage = skipPage;
    }

    private String startTime;
    private String endTime;

    public Integer getPageNo()
    {
        return pageNo;
    }

    public void setPageNo(Integer pageNo)
    {
        this.pageNo = pageNo;
    }

    public Integer getPageSize()
    {
        return pageSize;
    }

    public void setPageSize(Integer pageSize)
    {
        this.pageSize = pageSize;
    }

    public String getStartTime()
    {
        return startTime;
    }

    public void setStartTime(String startTime)
    {
        this.startTime = startTime;
    }

    public String getEndTime()
    {
        return endTime;
    }

    public void setEndTime(String endTime)
    {
        this.endTime = endTime;
    }
}
