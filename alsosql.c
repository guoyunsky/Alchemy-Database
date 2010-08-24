/*
  COPYRIGHT :Russ
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>

#include "redis.h"
#include "bt.h"
#include "row.h"
#include "index.h"
#include "join.h"
#include "store.h"
#include "zmalloc.h"
#include "alsosql.h"
#include "denorm.h"
#include "sql.h"

// FROM redis.c
#define RL4 redisLog(4,
extern struct sharedObjectsStruct shared;
extern struct redisServer server;

// GLOBALS
int Num_tbls;
extern int Num_indx;

char  CCOMMA       = ',';
char  CEQUALS      = '=';
char  CPERIOD      = '.';
char  CMINUS       = '-';

char *EQUALS       = "=";
char *EMPTY_STRING = "";
char *OUTPUT_DELIM = ",";
char *COLON        = ":";
char *COMMA        = ",";
char *PERIOD       = ".";
char *SPACE        = " ";

char *STORE        = "STORE";

char *Col_type_defs[] = {"TEXT", "INT" };

//TODO make these 4 a struct
robj          *Tbl_name     [MAX_NUM_TABLES];
int            Tbl_col_count[MAX_NUM_TABLES];
robj          *Tbl_col_name [MAX_NUM_TABLES][MAX_COLUMN_PER_TABLE];
unsigned char  Tbl_col_type [MAX_NUM_TABLES][MAX_COLUMN_PER_TABLE];
int            Tbl_virt_indx[MAX_NUM_TABLES];

extern robj          *Index_obj     [MAX_NUM_INDICES];
extern int            Index_on_table[MAX_NUM_INDICES];
extern int            Indexed_column[MAX_NUM_INDICES];
extern unsigned char  Index_type    [MAX_NUM_INDICES];
extern bool           Index_virt    [MAX_NUM_INDICES];

// HELPER_COMMANDS HELPER_COMMANDS HELPER_COMMANDS HELPER_COMMANDS
// HELPER_COMMANDS HELPER_COMMANDS HELPER_COMMANDS HELPER_COMMANDS
robj *cloneRobj(robj *r) { // must be decrRefCount()ed
    if (r->encoding == REDIS_ENCODING_RAW) {
        return createStringObject(r->ptr, sdslen(r->ptr));
    } else {
        robj *n     = createObject(REDIS_STRING, r->ptr);
        n->encoding = REDIS_ENCODING_INT;
        return n;
    }
}

int find_table(char *tname) {
    for (int i = 0; i < Num_tbls; i++) {
        if (Tbl_name[i]) {
            if (!strcmp(tname, (char *)Tbl_name[i]->ptr)) {
                return i;
            }
        }
    }
    return -1;
}

int find_column(int tmatch, char *column) {
    if (!Tbl_name[tmatch]) return -1;
    for (int j = 0; j < Tbl_col_count[tmatch]; j++) {
        if (Tbl_col_name[tmatch][j]) {
            if (!strcmp(column, (char *)Tbl_col_name[tmatch][j]->ptr)) {
                return j;
            }
        }
    }
    return -1;
}

static char *parseRowVals(sds            vals,
                          char         **pk,
                          int           *pklen,
                          int            ncols,
                          unsigned int   cofsts[]) {
    if (vals[sdslen(vals) - 1] == ')') vals[sdslen(vals) - 1] = '\0';
    if (*vals == '(') vals++;

    int   fieldnum = 0;
    char *token    = vals;
    char *nextc    = vals;
    while ((nextc = strchr(nextc, CCOMMA))) {
        unsigned char num_dbl_qts = 0;
        for (char *x = token; x < nextc; x++)  if (*x == '"') num_dbl_qts++;
        if (num_dbl_qts == 1) {
            nextc++;
            continue;
        }
        if (!*pk) {
            int   len = (nextc - vals);
            if (!len) return NULL;
            char *buf = zmalloc(len); /* z: sds hash-key */
            memcpy(buf, vals, len);
            *pk       = buf;
            *pklen    = len;
        }
        nextc++;
        token               = nextc;
        cofsts[fieldnum] = token - vals;
        fieldnum++;
    }
    int len             = strlen(token);
    cofsts[fieldnum] = (token - vals) + len + 1; // points 2 NULL terminatr
    fieldnum++;
    if (fieldnum != ncols) {
        return NULL;
    }
    return vals;
}

int parseColListOrReply(redisClient   *c,
                        int            tmatch,
                        char          *clist,
                        int            cmatchs[]) {
    if (*clist == '*') {
        for (int i = 0; i < Tbl_col_count[tmatch]; i++) {
            cmatchs[i] = i;
        }
        return Tbl_col_count[tmatch];
    }

    int   qcols  = 0;
    char *nextc = clist;
    while ((nextc = strchr(nextc, CCOMMA))) {
        *nextc = '\0';
        nextc++;
        COLUMN_CHECK_OR_REPLY(clist, 0)
        cmatchs[qcols] = cmatch;
        qcols++;
        clist = nextc;
    }
    COLUMN_CHECK_OR_REPLY(clist, 0)
    cmatchs[qcols] = cmatch;
    qcols++;
    return qcols;
}

int parseUpdateOrReply(redisClient  *c,
                       int           tmatch,
                       char         *cname,
                       int           cmatchs[],
                       char         *vals   [],
                       unsigned int  vlens  []) {
    int   qcols = 0;
    while (1) {
        char *val   = strchr(cname, CEQUALS);
        char *nextc = strchr(cname, CCOMMA);
        if (val) {
            *val = '\0';
            val++;
        } else {
            addReply(c, shared.invalidupdatestring);
            return 0;
        }
        if (nextc) {
            *nextc = '\0';
            nextc++;
        }

        int cmatch = find_column(tmatch, cname);
        if (cmatch == -1) {
            addReply(c, shared.nonexistentcolumn);
            return 0;
        }

        unsigned int val_len  = nextc ?  nextc - val - 1 :
                                         (unsigned int)strlen(val);

        cmatchs[qcols] = cmatch;
        vals    [qcols] = val;
        vlens[qcols] = val_len;
        qcols++;

        if (!nextc) break;
        cname = nextc;
    }
    return qcols;
}

// SIMPLE_COMMANDS SIMPLE_COMMANDS SIMPLE_COMMANDS SIMPLE_COMMANDS
// SIMPLE_COMMANDS SIMPLE_COMMANDS SIMPLE_COMMANDS SIMPLE_COMMANDS
bool cCpyOrReply(redisClient *c, char *src, char *dest, unsigned int len) {
    if (len >= MAX_COLUMN_NAME_SIZE) {
        addReply(c, shared.columnnametoobig);
        return 0;
    }
    memcpy(dest, src, len);
    dest[len] = '\0';
    return 1;
}

void createTableCommitReply(redisClient *c,
                            char         cnames[][MAX_COLUMN_NAME_SIZE],
                            int          col_count,
                            char        *tname) {
    if (col_count < 2) {
        addReply(c, shared.toofewcolumns);
        return;
    }

    // check for repeat column names
    for (int i = 0; i < col_count; i++) {
        for (int j = 0; j < col_count; j++) {
            if (i == j) continue;
            if (!strcmp(cnames[i], cnames[j])) {
                addReply(c, shared.nonuniquecolumns);
                return;
            }
        }
    }

    addReply(c, shared.ok);
    // commit table definition
    for (int i = 0; i < col_count; i++) {
        Tbl_col_name[Num_tbls][i] = createStringObject(cnames[i],
                                                       strlen(cnames[i]));
    }
    robj *tbl               = createStringObject(tname, strlen(tname));
    Tbl_col_count[Num_tbls] = col_count;
    Tbl_name     [Num_tbls] = tbl;
    robj *bt                = createBtreeObject(Tbl_col_type[Num_tbls][0],
                                                Num_tbls, BTREE_TABLE);
    dictAdd(c->db->dict, tbl, bt);
    // BTREE implies an index on "tbl:pk:index" -> autogenerate
    robj *iname = createStringObject(tname, strlen(tname));
    iname->ptr  = sdscatprintf(iname->ptr, "%s%s%s%s",
                                       COLON, cnames[0], COLON, INDEX_DELIM);
    newIndex(c, iname->ptr, Num_tbls, 0, 1);
    decrRefCount(iname);
    Num_tbls++;
}

void createTable(redisClient *c) {
    if (Num_tbls >= MAX_NUM_TABLES) {
        addReply(c, shared.toomanytables);
        return;
    }

    sds tname = c->argv[2]->ptr;
    if (find_table(tname) != -1) {
        addReply(c, shared.nonuniquetablenames);
        return;
    }

    if (!strcasecmp(c->argv[3]->ptr, "AS")) {
        createTableAsObject(c);
        return;
    }

    //TODO break out cnames into function -> sql.c
    char  cnames[MAX_COLUMN_PER_TABLE][MAX_COLUMN_NAME_SIZE];
    char *o_token  [MAX_COLUMN_PER_TABLE];
    int   argn;
    int   col_count      = 0;
    bool  parse_col_name = 1;
    bool  parse_col_type = 0;
    char *trailer        = NULL;
    for (argn = 3; argn < c->argc; argn++) {
        sds token  = sdsdup(c->argv[argn]->ptr);
        o_token[argn] = token;
        if (parse_col_name) {
            int len        = sdslen(token);
            if (*token == '(') { /* delete "(" @ begin */
                token++;
                len--;
                if (!len) continue; /* lone "(" */
            }
            if (!cCpyOrReply(c, token, cnames[col_count], len)) {
                goto create_table_err;
            }
            parse_col_name = 0;
            parse_col_type = 1;
        } else if (parse_col_type) {
            parse_col_type = 0;
            if (trailer) { /* when last token ended with "int,x" */
                int len = strlen(trailer);
                if (!cCpyOrReply(c, trailer, cnames[col_count], len)) {
                    goto create_table_err;
                }
            }
            trailer     = NULL;
            int   len   = sdslen(token);
            char *comma = strchr(token, CCOMMA);
            if (comma) {
                if ((comma - token) == (len - 1)) { /* delete "," @ end */
                    len--;
                    parse_col_name = 1;
                } else { /* means token ends w/ "int,x" */
                    len            -= (comma - token);
                    *comma          = '\0';
                    trailer         = comma + 1;
                    parse_col_type  = 1;
                }
            }
            if (token[len - 1] == ')') { /* delete "(.....)" */
                token[len - 1] = '\0';
                for (int j = len - 2; j > 0; j--) {
                    if (token[j] == '(') {
                        token[j]  = '\0';
                        len      -= ((len - 1) - j);
                        break;
                    }
                }
            }
            unsigned char miss = 1;
            for (unsigned char j = 0; j < NUM_COL_TYPES; j++) {
                if (!strncasecmp(token, Col_type_defs[j], len)) {
                    Tbl_col_type[Num_tbls][col_count] = j;
                    miss                              = 0;
                    break;
                }
            }
            if (miss) {
                addReply(c, shared.undefinedcolumntype);
                goto create_table_err;
            }
            col_count++;
        } else { /* ignore until "," */
            if (token[sdslen(token) - 1] == CCOMMA) parse_col_name = 1;
        }
    }
    createTableCommitReply(c, cnames, col_count, tname);

create_table_err:
    for (int j = 3; j < argn; j++) {
        sdsfree(o_token[j]);
    }
}


void createCommand(redisClient *c) {
    if (c->argc < 4) {
        addReply(c, shared.createsyntax);
        return;
    }
    bool create_table = 0;
    bool create_index = 0;
    if (!strcasecmp(c->argv[1]->ptr, "table")) {
        create_table = 1;
    }
    if (!strcasecmp(c->argv[1]->ptr, "index")) {
        create_index = 1;
    }

    if (!create_table && !create_index) {
        addReply(c, shared.createsyntax);
        return;
    }

    if (create_table) createTable(c);
    if (create_index) createIndex(c);
    server.dirty++; /* for appendonlyfile */
}

void insertCommitReply(redisClient *c,
                       sds          vals,
                       int          ncols,
                       int          tmatch,
                       int          matches,
                       int          indices[]) {
    unsigned int cofsts[MAX_COLUMN_PER_TABLE];
    char *pk     = NULL;
    int   pklen  = 0; /* init avoids compiler warning*/
    vals         = parseRowVals(vals, &pk, &pklen, ncols, cofsts);
    if (!vals) {
        addReply(c, shared.insertcolumnmismatch);
        return;
    }

    int   pktype = Tbl_col_type[tmatch][0];
    robj *o   = lookupKeyWrite(c->db, Tbl_name[tmatch]);
    robj *pko = createStringObject(pk, pklen);
    if (pktype == COL_TYPE_INT) {
        long l   = atol(pko->ptr);
        if (l >= TWO_POW_32) {
            addReply(c, shared.uint_pk_too_big);
            return;
        } else if (l < 0) {
            addReply(c, shared.uint_no_negative_values);
            return;
        }
    }
    robj *row = btFindVal(o, pko, pktype);
    if (row) {
        zfree(pk);
        decrRefCount(pko);
        addReply(c, shared.insertcannotoverwrite);
        return;
    }
    if (matches) { /* indices */
        for (int i = 0; i < matches; i++) {
            addToIndex(c->db, pko, vals, cofsts, indices[i]);
        }
    }

    /* createRow modifies vals' buffer in place */
    robj *nrow = createRow(c, tmatch, ncols, vals, cofsts);
    if (!nrow) return;
    int   len  = btAdd(o, pko, nrow, pktype); /* copy[pk & val] */
    decrRefCount(pko);
    decrRefCount(nrow);
    zfree(pk);

    int new_size = 0;
    if (c->argc > 5 &&
        !strcasecmp(c->argv[5]->ptr, "RETURN") &&
        !strcasecmp(c->argv[6]->ptr, "SIZE")      ) {
        new_size = len;
    }

    if (new_size) {
        char buf[128];
        bt  *btr        = (bt *)o->ptr;
        int  index_size = get_sum_all_index_size_for_table(c, tmatch);
        sprintf(buf,
                  "INFO: BYTES: [ROW: %d BT-DATA: %d BT-TOTAL: %d INDEX: %d]",
                   new_size, btr->data_size, btr->malloc_size, index_size);
        robj *r = createStringObject(buf, strlen(buf));
        addReplyBulk(c, r);
        decrRefCount(r);
    } else {
        addReply(c, shared.ok);
    }
}

void insertCommand(redisClient *c) {
   if (strcasecmp(c->argv[1]->ptr, "INTO")) {
        addReply(c, shared.insertsyntax_no_into);
        return;
    }

    TABLE_CHECK_OR_REPLY(c->argv[2]->ptr,)
    int ncols = Tbl_col_count[tmatch];
    MATCH_INDICES(tmatch)

    /* TODO column ordering is IGNORED */
    if (strcasecmp(c->argv[3]->ptr, "VALUES")) {
        char *x = c->argv[3]->ptr;
        if (*x == '(') addReply(c, shared.insertsyntax_col_declaration);
        else           addReply(c, shared.insertsyntax_no_values);
        return;
    }

    /* NOTE: INSERT only works if (vals,,,,,) has no spaces (CLIENT SIDE REQ) */
    sds vals = c->argv[4]->ptr;
    insertCommitReply(c, vals, ncols, tmatch, matches, indices);
}

void selectReply(redisClient  *c,
                 robj         *o,
                 robj         *pko,
                 int           tmatch,
                 int           cmatchs[],
                 int           qcols) {
    robj *row = btFindVal(o, pko, Tbl_col_type[tmatch][0]);
    if (!row) {
        addReply(c, shared.nullbulk);
        return;
    }

    robj *r = outputRow(row, qcols, cmatchs, pko, tmatch, 0);
    addReplyBulk(c, r);
    decrRefCount(r);
}

void selectALSOSQLCommand(redisClient *c) {
    int   argn;
    int   which = 0; /*used in ARGN_OVERFLOW */
    robj *pko   = NULL, *range = NULL;
    sds   clist = sdsempty();
    for (argn = 1; argn < c->argc; argn++) {
        sds y = c->argv[argn]->ptr;
        if (!strcasecmp(y, "FROM")) break;

        if (*y == CCOMMA) {
             if (sdslen(y) == 1) continue;
             y++;
        }
        char *nextc = y;
        while ((nextc = strrchr(nextc, CCOMMA))) {
            *nextc = '\0';
            nextc++;
            if (sdslen(clist)) clist  = sdscatlen(clist, COMMA, 1);
            clist  = sdscat(clist, y);
            y      = nextc;
        }
        if (*y) {
            if (sdslen(clist)) clist  = sdscatlen(clist, COMMA, 1);
            clist  = sdscat(clist, y);
        }
    }

    if (argn == c->argc) {
        addReply(c, shared.selectsyntax_nofrom);
        goto sel_cmd_err;
    }
    ARGN_OVERFLOW
    sds tbl_list = c->argv[argn]->ptr;
    bool join = 0;
    if (strchr(c->argv[argn]->ptr, CCOMMA)) join = 1;
    if (!join) {
        ARGN_OVERFLOW
        if (strcasecmp(c->argv[argn]->ptr, "WHERE")) {
            join = 1;
            argn--;
        }
    }

    if (join) {
        joinParseReply(c, clist, argn, which);
    } else {
        TABLE_CHECK_OR_REPLY(tbl_list,);

        int           imatch = -1;
        unsigned char where  = checkSQLWhereClauseOrReply(c, &pko, &range,
                                                          &imatch, NULL, &argn,
                                                          tmatch, 0);
        if (!where) goto sel_cmd_err;

        if (argn < (c->argc - 1)) { /* DENORM e.g.: STORE LPUSH list */
            ARGN_OVERFLOW
            if (!strcasecmp(c->argv[argn]->ptr, STORE)) {
                if (!range) {
                    addReply(c, shared.selectsyntax_store_norange);
                    goto sel_cmd_err;
                }
                ARGN_OVERFLOW
                int i = argn;
                ARGN_OVERFLOW
                istoreCommit(c, tmatch, imatch, c->argv[i]->ptr, clist,
                             range->ptr, c->argv[argn]);
            } else {
                addReply(c, shared.selectsyntax);
            }
        } else if (where == 2) { /* RANGE QUERY */
            iselectAction(c, range->ptr, tmatch, imatch, clist);
        } else {
            int cmatchs[MAX_COLUMN_PER_TABLE];
            int qcols = parseColListOrReply(c, tmatch, clist, cmatchs);
            if (!qcols) goto sel_cmd_err;
    
            robj *o = lookupKeyReadOrReply(c, Tbl_name[tmatch], shared.nullbulk);
            if (!o)     goto sel_cmd_err;
    
            selectReply(c, o, pko, tmatch, cmatchs, qcols);
        }
    }

sel_cmd_err:
    sdsfree(clist);
    if (pko)   decrRefCount(pko);
    if (range) decrRefCount(range);
}

void deleteCommand(redisClient *c) {
    if (strcasecmp(c->argv[1]->ptr, "FROM")) {
        addReply(c, shared.deletesyntax);
        return;
    }

    TABLE_CHECK_OR_REPLY(c->argv[2]->ptr,)

    int            imatch = -1;
    robj          *pko    = NULL, *range = NULL;
    int            argn   = 3;
    unsigned char  where  = checkSQLWhereClauseOrReply(c, &pko, &range, &imatch,
                                                       NULL, &argn, tmatch, 1);
    if (!where) return;

    if (where == 2) { /* RANGE QUERY */
        ideleteAction(c, range->ptr, tmatch, imatch);
    } else {
        MATCH_INDICES(tmatch)
        deleteRow(c, tmatch, pko, matches, indices) ? addReply(c, shared.cone) :
                                                      addReply(c, shared.czero);
    }
    if (pko)   decrRefCount(pko);
    if (range) decrRefCount(range);
}

void updateCommand(redisClient *c) {
    TABLE_CHECK_OR_REPLY(c->argv[1]->ptr,)

    if (strcasecmp(c->argv[2]->ptr, "SET")) {
        addReply(c, shared.updatesyntax);
        return;
    }

    int            cmatchs[MAX_COLUMN_PER_TABLE];
    char          *mvals  [MAX_COLUMN_PER_TABLE];
    unsigned int   mvlens [MAX_COLUMN_PER_TABLE];
    char          *nvals = c->argv[3]->ptr;
    int            ncols = Tbl_col_count[tmatch];
    int            qcols = parseUpdateOrReply(c, tmatch, nvals, cmatchs,
                                              mvals, mvlens);
    if (!qcols) return;
    MATCH_INDICES(tmatch)

    ASSIGN_UPDATE_HITS_AND_MISSES

    int            imatch = -1;
    robj          *pko    = NULL, *range = NULL;
    int            argn   = 4;
    unsigned char  where  = checkSQLWhereClauseOrReply(c, &pko, &range, &imatch,
                                                       NULL, &argn, tmatch, 2);
    if (!where) goto update_cmd_err;
    if (where == 2) { /* RANGE QUERY */
        iupdateAction(c, range->ptr, tmatch, imatch, ncols, matches, indices,
                      vals, vlens, cmiss);
    } else {
        robj *o = lookupKeyReadOrReply(c, Tbl_name[tmatch], shared.czero);
        if (!o) return;

        robj *row = btFindVal(o, pko, Tbl_col_type[tmatch][0]);
        if (!row) {
            addReply(c, shared.czero);
            goto update_cmd_err;
        }

        if (!updateRow(c, o, pko, row, tmatch, ncols, matches, indices, 
                       vals, vlens, cmiss)) goto update_cmd_err;

        addReply(c, shared.cone);
    }

update_cmd_err:
    if (pko)   decrRefCount(pko);
    if (range) decrRefCount(range);
}

static void dropTable(redisClient *c) {
    char *tname = c->argv[2]->ptr;
    TABLE_CHECK_OR_REPLY(tname,)
    MATCH_INDICES(tmatch)
    unsigned long deleted = 0;
    if (matches) { // delete indices first
        robj *index_del_list[MAX_COLUMN_PER_TABLE];
        for (int i = 0; i < matches; i++) { // build list of robj's to delete
            int inum          = indices[i];
            index_del_list[i] = Index_obj[inum];
        }
        for (int i = 0; i < matches; i++) { //delete index robj's
            deleteKey(c->db, index_del_list[i]);
            int inum             = indices[i];
            Index_obj     [inum] = NULL;
            Index_on_table[inum] = -1;
            Indexed_column[inum] = -1;
            deleted++;
        }
        //TODO shuffle indices to make space for deleted indices
    }

    deleteKey(c->db, Tbl_name[tmatch]);
    Tbl_name[tmatch] = NULL;
    deleted++;

    for (int j = 0; j < Tbl_col_count[tmatch]; j++) {
        decrRefCount(Tbl_col_name[tmatch][j]);
        Tbl_col_name[tmatch][j] = NULL;
    }
    //TODO shuffle tables to make space for deleted indices

    addReplyLongLong(c, deleted);
    server.dirty++;
}

void dropCommand(redisClient *c) {
    bool drop_table = 0;
    bool drop_index = 0;
    if (!strcasecmp(c->argv[1]->ptr, "table")) {
        drop_table = 1;
    }
    if (!strcasecmp(c->argv[1]->ptr, "index")) {
        drop_index = 1;
    }

    if (!drop_table && !drop_index) {
        addReply(c, shared.dropsyntax);
        return;
    }

    if (drop_table) dropTable(c);
    if (drop_index) dropIndex(c);
}