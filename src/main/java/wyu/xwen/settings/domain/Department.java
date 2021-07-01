package wyu.xwen.settings.domain;


public class Department
{

  private String id;
  private String name;
  private String manager;
  private String phone;
  private String description;
  private Integer pageNo;
  private Integer pageSize;
  private Integer skipPage;
  private String newId;

  public String getNewId()
  {
    return newId;
  }

  public void setNewId(String newId)
  {
    this.newId = newId;
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

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }


  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }


  public String getManager() {
    return manager;
  }

  public void setManager(String manager) {
    this.manager = manager;
  }


  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }


  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
