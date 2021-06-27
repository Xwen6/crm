package wyu.xwen.vo;

import wyu.xwen.workbench.domain.Clue;

public class ClueVo extends Clue {

    private String pageNo;
    private String pageSize;
    private Integer skinPage;

    public Integer getSkinPage() {
        return skinPage;
    }

    public void setSkinPage(Integer skinPage) {
        this.skinPage = skinPage;
    }

    public String getPageNo() {
        return pageNo;
    }

    public void setPageNo(String pageNo) {
        this.pageNo = pageNo;
    }

    public String getPageSize() {
        return pageSize;
    }

    public void setPageSize(String pageSize) {
        this.pageSize = pageSize;
    }


}
