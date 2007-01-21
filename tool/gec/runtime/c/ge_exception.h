/*
	description:

		"C functions used to implement class EXCEPTION"

	system: "Gobo Eiffel Compiler"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"
*/

#ifndef GE_EXCEPTION_H
#define GE_EXCEPTION_H

#include <setjmp.h>

/*
	On Linux glibc systems, we need to use sig* versions of jmp_buf,
	setjmp and longjmp to preserve the signal handling context.
	One way to detect this is if _SIGSET_H_types has
	been defined in /usr/include/setjmp.h.
	NOTE: ANSI only recognizes the non-sig versions.
*/
#if (defined(_SIGSET_H_types) && !defined(__STRICT_ANSI__))
#define gejmp_buf sigjmp_buf
#define gesetjmp(x) sigsetjmp((x),1)
#define gelongjmp(x,y) siglongjmp((x),(y))
#else
#define gejmp_buf jmp_buf
#define gesetjmp(x) setjmp((x))
#define gelongjmp(x,y) longjmp((x),(y))
#endif

/*
	Context of features containing a rescue clause.
*/
struct gerescue {
	gejmp_buf jb;
	struct gerescue *previous; /* previous context in the call chain */
};

/*
	Context of last feature entered containing a rescue clause.
	Warning: this is not thread-safe.
*/
extern struct gerescue *gerescue;

extern void geraise(int code);

#endif