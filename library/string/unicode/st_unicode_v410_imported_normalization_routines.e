indexing

	description:

		"Imported normalization routines for Unicode version 4.1.0"

	library: "Gobo Eiffel String Library"
	copyright: "Copyright (c) 2005, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ST_UNICODE_V410_IMPORTED_NORMALIZATION_ROUTINES

feature -- Access

	normalization_v410: ST_UNICODE_V410_NORMALIZATION_ROUTINES is
			-- Unicode character class routines
		once
			create Result
		ensure
			normalization_v410_not_void: Result /= Void
		end

end

