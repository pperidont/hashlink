/*
 * Copyright (C)2005-2016 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
#include <hl.h>

#define H_SIZE_INIT 7
#define H_CELL_SIZE	3

// successive primes that double every time
static int H_PRIMES[] = {
	7,17,37,79,163,331,673,1361,2729,5471,10949,21911,43853,87613,175229,350459,700919,1401857,2803727,5607457,11214943,22429903,44859823,89719661,179424673,373587883,776531401,1611623773
};

typedef struct _hl_bytes_map hl_bytes_map;
typedef struct _hl_bytes_cell hl_bytes_cell;

struct _hl_bytes_cell {
	int nvalues;
	int hashes[H_CELL_SIZE];
	uchar *strings[H_CELL_SIZE];
	vdynamic *values[H_CELL_SIZE];
	hl_bytes_cell *next;
};

struct _hl_bytes_map {
	hl_bytes_cell **cells;
	int ncells;
	int nentries;
};

HL_PRIM hl_bytes_map *hl_hballoc() {
	hl_bytes_map *m = (hl_bytes_map*)hl_gc_alloc_raw(sizeof(hl_bytes_map));
	m->ncells = H_SIZE_INIT;
	m->nentries = 0;
	m->cells = (hl_bytes_cell **)hl_gc_alloc_raw(sizeof(hl_bytes_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	return m;
}

static vdynamic **hl_hbfind( hl_bytes_map *m, uchar *key ) {
	int hash = hl_hash_gen(key,false) | 1;
	int ckey = (((unsigned)hash)>>1) % ((unsigned)m->ncells);
	hl_bytes_cell *c = m->cells[ckey];
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->hashes[i] == hash && ucmp(key,c->strings[i]) == 0 )
				return c->values + i;
		c = c->next;
	}
	return NULL;
}

static void hl_hbremap( hl_bytes_map *m, uchar *key, int hash, vdynamic *value, hl_bytes_cell **reuse ) {
	int ckey = (((unsigned)hash)>>1) % ((unsigned)m->ncells);
	hl_bytes_cell *c = m->cells[ckey];
	if( c && c->nvalues < H_CELL_SIZE ) {
		c->hashes[c->nvalues] = hash;
		c->strings[c->nvalues] = key;
		c->values[c->nvalues] = value;
		c->nvalues++;
		return;
	}
	c = *reuse;
	if( c )
		*reuse = c->next;
	else
		c = (hl_bytes_cell*)hl_gc_alloc_raw(sizeof(hl_bytes_cell));
	memset(c,0,sizeof(hl_bytes_cell));
	c->strings[0] = key;
	c->hashes[0] = hash;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
}

static bool hl_hbadd( hl_bytes_map *m, uchar *key, vdynamic *value ) {
	int hash = hl_hash_gen(key,false) | 1;
	int ckey = (((unsigned)hash)>>1) % ((unsigned)m->ncells);
	hl_bytes_cell *c = m->cells[ckey];
	hl_bytes_cell *pspace = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->hashes[i] == hash && ucmp(key,c->strings[i]) == 0 ) {
				c->values[i] = value;
				return false;
			}
		if( !pspace && c->nvalues < H_CELL_SIZE ) pspace = c;
		c = c->next;
	}
	if( pspace ) {
		pspace->hashes[pspace->nvalues] = hash;
		pspace->strings[pspace->nvalues] = key;
		pspace->values[pspace->nvalues] = value;
		pspace->nvalues++;
		m->nentries++;
		return false;
	}
	c = (hl_bytes_cell*)hl_gc_alloc_raw(sizeof(hl_bytes_cell));
	memset(c,0,sizeof(hl_bytes_cell));
	c->strings[0] = key;
	c->hashes[0] = hash;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
	m->nentries++;
	return true;
}

static void hl_hbgrow( hl_bytes_map *m ) {
	int i = 0;
	int oldsize = m->ncells;
	hl_bytes_cell **old_cells = m->cells;
	hl_bytes_cell *reuse = NULL;
	while( H_PRIMES[i] <= m->ncells ) i++;
	hl_add_root(&old_cells);
	m->ncells = H_PRIMES[i];
	m->cells = (hl_bytes_cell **)hl_gc_alloc_raw(sizeof(hl_bytes_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	for(i=0;i<oldsize;i++) {
		hl_bytes_cell *c = old_cells[i];
		while( c ) {
			hl_bytes_cell *next = c->next;
			int j;
			for(j=0;j<c->nvalues;j++) {
				if( j == c->nvalues-1 ) {
					c->next = reuse;
					reuse = c;
				}
				hl_hbremap(m,c->strings[j],c->hashes[j],c->values[j],&reuse);
			}
			c = next;
		}
	}
	hl_pop_root();
}

HL_PRIM void hl_hbset( hl_bytes_map *m, vbyte *key, vdynamic *value ) {
	if( hl_hbadd(m,(uchar*)key,value) && m->nentries > m->ncells * H_CELL_SIZE * 2 )
		hl_hbgrow(m);
}

HL_PRIM bool hl_hbexists( hl_bytes_map *m, vbyte *key ) {
	return hl_hbfind(m,(uchar*)key) != NULL;
}

HL_PRIM vdynamic* hl_hbget( hl_bytes_map *m, vbyte *key ) {
	vdynamic **v = hl_hbfind(m,(uchar*)key);
	if( v == NULL ) return NULL;
	return *v;
}

HL_PRIM bool hl_hbremove( hl_bytes_map *m, vbyte *_key ) {
	uchar *key = (uchar*)_key;
	int hash = hl_hash_gen(key,false) | 1;
	int ckey = (((unsigned)hash)>>1) % ((unsigned)m->ncells);
	hl_bytes_cell *c = m->cells[ckey];
	hl_bytes_cell *prev = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->hashes[i] == hash && ucmp(c->strings[i],key) == 0 ) {
				c->nvalues--;
				m->nentries--;
				if( c->nvalues ) {
					int j;
					for(j=i;j<c->nvalues;j++) {
						c->hashes[j] = c->hashes[j+1];
						c->strings[j] = c->strings[j+1];
						c->values[j] = c->values[j+1];
					}
					c->strings[j] = NULL;
					c->values[j] = NULL; // GC friendly
				} else if( prev )
					prev->next = c->next;
				else
					m->cells[ckey] = c->next;
				return true;
			}
		prev = c;
		c = c->next;
	}
	return false;
}

HL_PRIM varray* hl_hbkeys( hl_bytes_map *m ) {
	varray *a = hl_alloc_array(&hlt_bytes,m->nentries);
	uchar **keys = hl_aptr(a,uchar*);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_bytes_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				keys[p++] = c->strings[j];
			c = c->next;
		}
	}
	return a;
}

HL_PRIM varray* hl_hbvalues( hl_bytes_map *m ) {
	varray *a = hl_alloc_array(&hlt_dyn,m->nentries);
	vdynamic **values = hl_aptr(a,vdynamic*);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_bytes_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				values[p++] = c->values[j];
			c = c->next;
		}
	}
	return a;
}

// ----- INT MAP ---------------------------------

typedef struct _hl_int_map hl_int_map;
typedef struct _hl_int_cell hl_int_cell;

struct _hl_int_cell {
	int nvalues;
	int keys[H_CELL_SIZE];
	vdynamic *values[H_CELL_SIZE];
	hl_int_cell *next;
};

struct _hl_int_map {
	hl_int_cell **cells;
	int ncells;
	int nentries;
};

HL_PRIM hl_int_map *hl_hialloc() {
	hl_int_map *m = (hl_int_map*)hl_gc_alloc_raw(sizeof(hl_int_map));
	m->ncells = H_SIZE_INIT;
	m->nentries = 0;
	m->cells = (hl_int_cell **)hl_gc_alloc_raw(sizeof(hl_int_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	return m;
}

static vdynamic **hl_hifind( hl_int_map *m, int key ) {
	int ckey = ((unsigned)key) % ((unsigned)m->ncells);
	hl_int_cell *c = m->cells[ckey];
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key )
				return c->values + i;
		c = c->next;
	}
	return NULL;
}

static void hl_hiremap( hl_int_map *m, int key, vdynamic *value, hl_int_cell **reuse ) {
	int ckey = ((unsigned)key) % ((unsigned)m->ncells);
	hl_int_cell *c = m->cells[ckey];
	if( c && c->nvalues < H_CELL_SIZE ) {
		c->keys[c->nvalues] = key;
		c->values[c->nvalues] = value;
		c->nvalues++;
		return;
	}
	c = *reuse;
	if( c )
		*reuse = c->next;
	else
		c = (hl_int_cell*)hl_gc_alloc_raw(sizeof(hl_int_cell));
	memset(c,0,sizeof(hl_int_cell));
	c->keys[0] = key;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
}

static bool hl_hiadd( hl_int_map *m, int key, vdynamic *value ) {
	int ckey = ((unsigned)key) % ((unsigned)m->ncells);
	hl_int_cell *c = m->cells[ckey];
	hl_int_cell *pspace = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key ) {
				c->values[i] = value;
				return false;
			}
		if( !pspace && c->nvalues < H_CELL_SIZE ) pspace = c;
		c = c->next;
	}
	if( pspace ) {
		pspace->keys[pspace->nvalues] = key;
		pspace->values[pspace->nvalues] = value;
		pspace->nvalues++;
		m->nentries++;
		return false;
	}
	c = (hl_int_cell*)hl_gc_alloc_raw(sizeof(hl_int_cell));
	memset(c,0,sizeof(hl_int_cell));
	c->keys[0] = key;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
	m->nentries++;
	return true;
}

static void hl_higrow( hl_int_map *m ) {
	int i = 0;
	int oldsize = m->ncells;
	hl_int_cell **old_cells = m->cells;
	hl_int_cell *reuse = NULL;
	while( H_PRIMES[i] <= m->ncells ) i++;
	/*
		GCC will store [old_cells+i] into a register, which will make the GC
		not able to find anymore the base address. Let's make sure it doesn't
		get collected until we're done.
	*/
	hl_add_root(&old_cells);
	m->ncells = H_PRIMES[i];
	m->cells = (hl_int_cell **)hl_gc_alloc_raw(sizeof(hl_int_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	for(i=0;i<oldsize;i++) {
		hl_int_cell *c = old_cells[i];
		while( c ) {
			hl_int_cell *next = c->next;
			int j;
			for(j=0;j<c->nvalues;j++) {
				if( j == c->nvalues-1 ) {
					c->next = reuse;
					reuse = c;
				}
				hl_hiremap(m,c->keys[j],c->values[j],&reuse);
			}
			c = next;
		}
	}
	hl_pop_root();
}

HL_PRIM void hl_hiset( hl_int_map *m, int key, vdynamic *value ) {
	if( hl_hiadd(m,key,value) && m->nentries > m->ncells * H_CELL_SIZE * 2 )
		hl_higrow(m);
}

HL_PRIM bool hl_hiexists( hl_int_map *m, int key ) {
	return hl_hifind(m,key) != NULL;
}

HL_PRIM vdynamic* hl_higet( hl_int_map *m, int key ) {
	vdynamic **v = hl_hifind(m,key);
	if( v == NULL ) return NULL;
	return *v;
}

HL_PRIM bool hl_hiremove( hl_int_map *m, int key ) {
	int ckey = ((unsigned)key) % ((unsigned)m->ncells);
	hl_int_cell *c = m->cells[ckey];
	hl_int_cell *prev = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key ) {
				c->nvalues--;
				m->nentries--;
				if( c->nvalues ) {
					int j;
					for(j=i;j<c->nvalues;j++) {
						c->keys[j] = c->keys[j+1];
						c->values[j] = c->values[j+1];
					}
					c->values[j] = NULL; // GC friendly
				} else if( prev )
					prev->next = c->next;
				else
					m->cells[ckey] = c->next;
				return true;
			}
		prev = c;
		c = c->next;
	}
	return false;
}

HL_PRIM varray* hl_hikeys( hl_int_map *m ) {
	varray *a = hl_alloc_array(&hlt_i32,m->nentries);
	int *keys = hl_aptr(a,int);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_int_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				keys[p++] = c->keys[j];
			c = c->next;
		}
	}
	return a;
}

HL_PRIM varray* hl_hivalues( hl_int_map *m ) {
	varray *a = hl_alloc_array(&hlt_dyn,m->nentries);
	vdynamic **values = hl_aptr(a,vdynamic*);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_int_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				values[p++] = c->values[j];
			c = c->next;
		}
	}
	return a;
}

// ------- OBJ MAP --------------------------------------

typedef struct _hl_obj_map hl_obj_map;
typedef struct _hl_obj_cell hl_obj_cell;

struct _hl_obj_cell {
	int nvalues;
	vdynamic *keys[H_CELL_SIZE];
	vdynamic *values[H_CELL_SIZE];
	hl_obj_cell *next;
};

struct _hl_obj_map {
	hl_obj_cell **cells;
	int ncells;
	int nentries;
};

HL_PRIM hl_obj_map *hl_hoalloc() {
	hl_obj_map *m = (hl_obj_map*)hl_gc_alloc_raw(sizeof(hl_obj_map));
	m->ncells = H_SIZE_INIT;
	m->nentries = 0;
	m->cells = (hl_obj_cell **)hl_gc_alloc_raw(sizeof(hl_obj_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	return m;
}

static vdynamic **hl_hofind( hl_obj_map *m, vdynamic *key ) {
	int hash = (int)(int_val)key;
	int ckey = ((unsigned)hash) % ((unsigned)m->ncells);
	hl_obj_cell *c = m->cells[ckey];
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key )
				return c->values + i;
		c = c->next;
	}
	return NULL;
}

static void hl_horemap( hl_obj_map *m, vdynamic *key, vdynamic *value, hl_obj_cell **reuse ) {
	int hash = (int)(int_val)key;
	int ckey = ((unsigned)hash) % ((unsigned)m->ncells);
	hl_obj_cell *c = m->cells[ckey];
	if( c && c->nvalues < H_CELL_SIZE ) {
		c->keys[c->nvalues] = key;
		c->values[c->nvalues] = value;
		c->nvalues++;
		return;
	}
	c = *reuse;
	if( c )
		*reuse = c->next;
	else
		c = (hl_obj_cell*)hl_gc_alloc_raw(sizeof(hl_obj_cell));
	memset(c,0,sizeof(hl_obj_cell));
	c->keys[0] = key;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
}

static bool hl_hoadd( hl_obj_map *m, vdynamic *key, vdynamic *value ) {
	int hash = (int)(int_val)key;
	int ckey = ((unsigned)hash) % ((unsigned)m->ncells);
	hl_obj_cell *c = m->cells[ckey];
	hl_obj_cell *pspace = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key ) {
				c->values[i] = value;
				return false;
			}
		if( !pspace && c->nvalues < H_CELL_SIZE ) pspace = c;
		c = c->next;
	}
	if( pspace ) {
		pspace->keys[pspace->nvalues] = key;
		pspace->values[pspace->nvalues] = value;
		pspace->nvalues++;
		m->nentries++;
		return false;
	}
	c = (hl_obj_cell*)hl_gc_alloc_raw(sizeof(hl_obj_cell));
	memset(c,0,sizeof(hl_obj_cell));
	c->keys[0] = key;
	c->values[0] = value;
	c->nvalues = 1;
	c->next = m->cells[ckey];
	m->cells[ckey] = c;
	m->nentries++;
	return true;
}

static void hl_hogrow( hl_obj_map *m ) {
	int i = 0;
	int oldsize = m->ncells;
	hl_obj_cell **old_cells = m->cells;
	hl_obj_cell *reuse = NULL;
	while( H_PRIMES[i] <= m->ncells ) i++;
	hl_add_root(&old_cells);
	m->ncells = H_PRIMES[i];
	m->cells = (hl_obj_cell **)hl_gc_alloc_raw(sizeof(hl_obj_cell*)*m->ncells);
	memset(m->cells,0,m->ncells * sizeof(void*));
	for(i=0;i<oldsize;i++) {
		hl_obj_cell *c = old_cells[i];
		while( c ) {
			hl_obj_cell *next = c->next;
			int j;
			for(j=0;j<c->nvalues;j++) {
				if( j == c->nvalues-1 ) {
					c->next = reuse;
					reuse = c;
				}
				hl_horemap(m,c->keys[j],c->values[j],&reuse);
			}
			c = next;
		}
	}
	hl_pop_root();
}

static vdynamic *no_virtual( vdynamic *k ) {
	return k && k->t->kind == HVIRTUAL ? hl_virtual_make_value((vvirtual*)k) : k;
}

HL_PRIM void hl_hoset( hl_obj_map *m, vdynamic *key, vdynamic *value ) {
	if( hl_hoadd(m,no_virtual(key),value) && m->nentries > m->ncells * H_CELL_SIZE * 2 )
		hl_hogrow(m);
}

HL_PRIM bool hl_hoexists( hl_obj_map *m, vdynamic *key ) {
	return hl_hofind(m,no_virtual(key)) != NULL;
}

HL_PRIM vdynamic* hl_hoget( hl_obj_map *m, vdynamic *key ) {
	vdynamic **v = hl_hofind(m,no_virtual(key));
	if( v == NULL ) return NULL;
	return *v;
}

HL_PRIM bool hl_horemove( hl_obj_map *m, vdynamic *_key ) {
	vdynamic *key = no_virtual(_key);
	int hash = (int)(int_val)key;
	int ckey = ((unsigned)hash) % ((unsigned)m->ncells);
	hl_obj_cell *c = m->cells[ckey];
	hl_obj_cell *prev = NULL;
	int i;
	while( c ) {
		for(i=0;i<c->nvalues;i++)
			if( c->keys[i] == key ) {
				c->nvalues--;
				m->nentries--;
				if( c->nvalues ) {
					int j;
					for(j=i;j<c->nvalues;j++) {
						c->keys[j] = c->keys[j+1];
						c->values[j] = c->values[j+1];
					}
					c->keys[j] = NULL;
					c->values[j] = NULL; // GC friendly
				} else if( prev )
					prev->next = c->next;
				else
					m->cells[ckey] = c->next;
				return true;
			}
		prev = c;
		c = c->next;
	}
	return false;
}

HL_PRIM varray* hl_hokeys( hl_obj_map *m ) {
	varray *a = hl_alloc_array(&hlt_dyn,m->nentries);
	vdynamic **keys = hl_aptr(a,vdynamic*);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_obj_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				keys[p++] = c->keys[j];
			c = c->next;
		}
	}
	return a;
}

HL_PRIM varray* hl_hovalues( hl_obj_map *m ) {
	varray *a = hl_alloc_array(&hlt_dyn, m->nentries);
	vdynamic **values = hl_aptr(a,vdynamic*);
	int p = 0;
	int i;
	for(i=0;i<m->ncells;i++) {
		int j;
		hl_obj_cell *c = m->cells[i];
		while( c ) {
			for(j=0;j<c->nvalues;j++)
				values[p++] = c->values[j];
			c = c->next;
		}
	}
	return a;
}

#define _BMAP _ABSTRACT(hl_bytes_map)
DEFINE_PRIM( _BMAP, hballoc, _NO_ARG );
DEFINE_PRIM( _VOID, hbset, _BMAP _BYTES _DYN );
DEFINE_PRIM( _BOOL, hbexists, _BMAP _BYTES );
DEFINE_PRIM( _DYN, hbget, _BMAP _BYTES );
DEFINE_PRIM( _BOOL, hbremove, _BMAP _BYTES );
DEFINE_PRIM( _ARR, hbkeys, _BMAP );
DEFINE_PRIM( _ARR, hbvalues, _BMAP );

#define _IMAP _ABSTRACT(hl_int_map)
DEFINE_PRIM( _IMAP, hialloc, _NO_ARG );
DEFINE_PRIM( _VOID, hiset, _IMAP _I32 _DYN );
DEFINE_PRIM( _BOOL, hiexists, _IMAP _I32 );
DEFINE_PRIM( _DYN, higet, _IMAP _I32 );
DEFINE_PRIM( _BOOL, hiremove, _IMAP _I32 );
DEFINE_PRIM( _ARR, hikeys, _IMAP );
DEFINE_PRIM( _ARR, hivalues, _IMAP );

#define _OMAP _ABSTRACT(hl_obj_map)
DEFINE_PRIM( _OMAP, hoalloc, _NO_ARG );
DEFINE_PRIM( _VOID, hoset, _OMAP _DYN _DYN );
DEFINE_PRIM( _BOOL, hoexists, _OMAP _DYN );
DEFINE_PRIM( _DYN, hoget, _OMAP _DYN );
DEFINE_PRIM( _BOOL, horemove, _OMAP _DYN );
DEFINE_PRIM( _ARR, hokeys, _OMAP );
DEFINE_PRIM( _ARR, hovalues, _OMAP );
