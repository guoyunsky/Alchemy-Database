/*
 * Implements jstore and join
 *

MIT License

Copyright (c) 2010 Russell Sullivan <jaksprats AT gmail DOT com>
ALL RIGHTS RESERVED 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */

#ifndef __JOINSTORE__H
#define __JOINSTORE__H

#include "adlist.h"
#include "redis.h"

#include "sql.h"
#include "common.h"

void freeJoinRowObject(robj *o);
void freeAppendSetObject(robj *o);
void freeValSetObject(robj *o);

int parseIndexedColumnListOrReply(redisClient *c, char *ilist, int j_indxs[]);

void joinGeneric(redisClient *c,
                 redisClient *fc,
                 jb_t        *jb,
                 bool         sub_pk,
                 int          nargc);

void jstoreCommit(redisClient *c, jb_t *jb);

#endif /* __JOINSTORE__H */ 
