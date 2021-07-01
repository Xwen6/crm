package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    int deleteRelation(String id);

    int addRelation(ClueActivityRelation relation);

    List<ClueActivityRelation> getClueActivityRelationByClueId(String clueId);

    int deleteRelationByClueId(String clueId);
}
