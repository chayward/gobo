indexing

	description:

		"Eiffel manifest strings"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_MANIFEST_STRING

inherit

	ET_CONSTANT
		undefine
			first_position, last_position
		redefine
			is_string_constant
		end

	ET_MANIFEST_STRING_ITEM
		undefine
			first_position, last_position
		end

	ET_INDEXING_TERM
		undefine
			first_position, last_position
		end

	ET_EXTERNAL_LANGUAGE
		undefine
			first_position, last_position
		end

	ET_EXTERNAL_ALIAS
		undefine
			first_position, last_position
		end

	ET_OBSOLETE
		undefine
			first_position, last_position
		end

	ET_AST_LEAF
		rename
			make as make_leaf,
			make_with_position as make_leaf_with_position
		end

feature -- Access

	value: STRING is
			-- String value
		deferred
		end

	literal: STRING is
			-- Literal value
		deferred
		end

	manifest_string: ET_MANIFEST_STRING is
			-- Manifest string
		do
			Result := Current
		end

feature -- Status report

	is_string_constant: BOOLEAN is True
			-- Is current constant a STRING constant?

invariant

	literal_not_void: literal /= Void
	value_not_void: value /= Void

end
