package wyu.xwen.workbench.dao;

import wyu.xwen.workbench.domain.ClueActivityRelation;

public interface ClueActivityRelationDao {
    int deleteRelation(String id);

    int addRelation(ClueActivityRelation relation);
}
