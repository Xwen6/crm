package wyu.xwen.workbench.service;

import wyu.xwen.exception.ClueDeleteException;
import wyu.xwen.workbench.domain.Activity;
import wyu.xwen.workbench.domain.Clue;
import wyu.xwen.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueService {
    Object pageList(Map<String,Object> map);

    Boolean saveClue(Clue clue);

    Clue getClueById(String id);

    Boolean updateClue(Clue clue);

    Boolean deleteClue(String[] ids) throws ClueDeleteException;

    List<ClueRemark> getClueRemarkByClueId(String clueId);

    Boolean updateRemark(ClueRemark remark);

    Boolean deleteRemark(String id);

    Boolean saveRemark(ClueRemark remark);

    List<Activity> getActivityByClueId(String clueId);

    Boolean relieve(String id);

    List<Activity> notAssociated(Map<String,Object> map);

    Boolean saveRelation(String[] activityId, String clueId);
}
