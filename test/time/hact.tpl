-- system:     "Gobo Eiffel Time Library Tester"
-- compiler:   "Halstenbach ISS-BASE 3.0"
-- author:     "Eric Bezault <ericb@gobosoft.com>"
-- copyright:  "Copyright (c) 2000, Eric Bezault and others"
-- license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
-- date:       "$Date$"
-- revision:   "$Revision$"

system

	xtime

root

	XTIME: "make"

default

	--debug (yes);
#ifdef ASSERTION
	assertion (all);
#else
	--assertion (all);
#endif
	--precompiled ("$ISS_BASE/spec/$PLATFORM/precomp/base")

cluster

	dt_testgen:			"TESTGEN";
	dt_tester:			"$GOBO/test/time";

#include "${GOBO}/library/time/hact.ace"

#include "${GOBO}/library/test/hact-skl.ace"

#include "${GOBO}/library/kernel/hact.ace"

#include "${GOBO}/library/structure/hact.ace"

#include "${GOBO}/library/utility/hact.ace"

component

		-- ISS-Baselib
	base: "$ISS_BASE/spec/$PLATFORM/component/base.cl"

end
