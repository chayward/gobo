indexing

	description:

		"Media types as defined in RFC2045. %
		%No facility is provided for parsing the MIME Content-Type %
		%header at present. Nor is the syntax of names rigidly %
		%checked at present."

	library: "Gobo Eiffel Utility Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class UT_MEDIA_TYPE

inherit

	ANY

	KL_IMPORTED_ANY_ROUTINES

creation

	make

feature {NONE} -- Initialization

	make (a_type, a_subtype: STRING) is
			-- Create a new media type.
		require
			a_type_not_void: a_type /= Void
			a_type_not_empty: a_type.count > 0
			a_type_string: ANY_.same_types (a_type, "")
			a_subtype_not_void: a_subtype /= Void
			a_subtype_not_empty: a_subtype.count > 0
			a_subtype_string: ANY_.same_types (a_subtype, "")
			-- TODO: should these be printable ASCII, or some subset? RFC2045 does not appear to say.
		do
			type := a_type.as_lower
			subtype := a_subtype.as_lower
			create parameters.make (10)
		ensure
			type_set: type.is_equal (a_type.as_lower)
			subtype_set: subtype.is_equal (a_subtype.as_lower)
		end

feature -- Access

	type: STRING
			-- Type

	subtype: STRING
			-- Subtype

	value (a_parameter: STRING): STRING is
			-- Value for `a_parameter'?
		require
			a_parameter_not_void: a_parameter /= Void
			a_paramater_string: ANY_.same_types (a_parameter, "")
			valid_parameter_name: is_valid_parameter_name (a_parameter)
			has_parameter: has (a_parameter)
		do
			Result := parameters.item (a_parameter.as_lower)
		ensure
			value_not_void: Result /= Void
		end

feature -- Status report

	has (a_parameter: STRING): BOOLEAN is
			-- Does `Current' have a parameter named `a_parameter'?
		require
			a_parameter_not_void: a_parameter /= Void
			a_paramater_string: ANY_.same_types (a_parameter, "")
			valid_parameter_name: is_valid_parameter_name (a_parameter)
		do
			Result := parameters.has (a_parameter.as_lower)
		end

	is_valid_parameter_name (a_parameter: STRING): BOOLEAN is
			-- Is `a_parameter' a legitimate parameter name?
		require
			a_parameter_not_void: a_parameter /= Void
			a_paramater_string: ANY_.same_types (a_parameter, "")
		do
			Result := is_token (a_parameter, False)
		end

	is_token (a_string: STRING; allow_specials: BOOLEAN): BOOLEAN is
			-- Is `a_string' a token?
		require
			a_string_not_void: a_string /= Void
		local
			an_index, a_count, a_code: INTEGER
		do
			from
				Result := True
				a_count := a_string.count
				an_index := 1
			variant
				a_count + 1 - an_index
			until
				Result = False or else an_index > a_count
			loop
				a_code := a_string.item_code (an_index)
				if a_code < 21 then
					Result := False
				elseif a_code > 126 then
					Result := False
				else
					inspect a_string.item (an_index)
					when ')', '(', '<', '>', '@', ',', ';', ':', '\', '"', '/', '%(', '%)', '?', '=' then
						Result := allow_specials
					else
						Result := True
					end
					an_index := an_index + 1
				end
			end
		end

feature -- Element change

	add_parameter (a_parameter, a_value: STRING) is
			-- Add new parameter `a_parameter' with value `a_value'.
		require
			a_parameter_not_void: a_parameter /= Void
			a_paramater_string: ANY_.same_types (a_parameter, "")
			valid_parameter_name: is_valid_parameter_name (a_parameter)
			not_has_parameter: not has (a_parameter)
			a_value_not_void: a_value /= Void
			a_value_string: ANY_.same_types (a_value, "")
			valid_value: is_token (a_value, True)
		do
			parameters.force (a_value, a_parameter.as_lower)
		ensure
			has_parameter: has (a_parameter)
			value_set: value (a_parameter) = a_value
		end

feature {NONE} -- Implementation

	parameters: DS_HASH_TABLE [STRING, STRING]
			-- Defined parameters

invariant

	type_not_void: type /= Void
	type_not_empty: type.count > 0
	type_is_lower_case: type.is_equal (type.as_lower)
	subtype_not_void: subtype /= Void
	subtype_not_empty: subtype.count > 0
	subtype_is_lower_case: subtype.is_equal (subtype.as_lower)
	parameters_not_void: parameters /= Void
	no_void_parameter: not parameters.has_item (Void)

end
