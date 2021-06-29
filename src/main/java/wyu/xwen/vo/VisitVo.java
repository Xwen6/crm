package wyu.xwen.vo;

import wyu.xwen.workbench.domain.Visit;

public class VisitVo extends Visit
{
    private Integer pageNo;
    private Integer pageSize;
    private Integer skipPage;
    private String contactsName;
    private String ownerName;
    private String createName;
    private String editName;

    public String getEditName()
    {
        return editName;
    }

    public void setEditName(String editName)
    {
        this.editName = editName;
    }

    public String getCreateName()
    {
        return createName;
    }

    public void setCreateName(String createName)
    {
        this.createName = createName;
    }

    public String getContactsName()
    {
        return contactsName;
    }

    public void setContactsName(String contactsName)
    {
        this.contactsName = contactsName;
    }

    public String getOwnerName()
    {
        return ownerName;
    }

    public void setOwnerName(String ownerName)
    {
        this.ownerName = ownerName;
    }

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
