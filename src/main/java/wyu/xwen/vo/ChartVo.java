package wyu.xwen.vo;

public class ChartVo {
    private String countKey;
    private String countValue;
    private Integer value;
    private String name;

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountKey() {
        return countKey;
    }

    public void setCountKey(String countKey) {
        this.countKey = countKey;
    }

    public String getCountValue() {
        return countValue;
    }

    public void setCountValue(String countValue) {
        this.countValue = countValue;
    }
}
