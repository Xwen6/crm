package wyu.xwen.vo;

import wyu.xwen.workbench.domain.Visit;

public class VisitVo extends Visit
{
    private Integer pageNo;
    private Integer pageSize;
    private Integer skipPage;

    public Integer getSkipPage()
    {
        return skipPage;
    }

    public void setSkipPage(Integer skipPage)
    {
        this.skipPage = skipPage;
    }

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
}
