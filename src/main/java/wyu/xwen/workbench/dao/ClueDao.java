package wyu.xwen.workbench.dao;

import wyu.xwen.vo.ClueVo;
import wyu.xwen.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int getTotalByCondition(Map<String,Object> map);

    List<Clue> getPageListByCondition(Map<String,Object> map);

    int saveClue(Clue clue);

    Clue getClueById(String id);

    int updateClue(Clue clue);

    int deleteClue(String id);
}
