indexing

	description:

		"Xace XML preprocessor"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_XACE_PREPROCESSOR

inherit

	ANY -- Export ANY's features

	ET_XACE_ELEMENT_NAMES
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make (a_variables: like variables; an_error_handler: like error_handler) is
			-- Create a new Xace XML preprocessor.
			-- Use `a_variables' for variable expansion.
			-- Use `a_variables' to decide whether "if" and "unless"
			-- elements will be stripped off or not.
		require
			a_variables_not_void: a_variables /= Void
			an_error_handler_not_void: an_error_handler /= Void
		do
			variables := a_variables
			error_handler := an_error_handler
		ensure
			variables_set: variables = a_variables
			error_handler_set: error_handler = an_error_handler
		end

feature -- Access

	variables: ET_XACE_VARIABLES
			-- Dollar variables defined

	error_handler: ET_XACE_ERROR_HANDLER
			-- Error handler

feature -- Preprocessing

	preprocess_composite (a_composite: XM_COMPOSITE; a_position_table: XM_POSITION_TABLE) is
			-- Expand variables in all attributes from `a_composite' and strip
			-- elements if they have "if" or "unless" attributes which do not
			-- evaluate to `True'.
		require
			a_composite_not_void: a_composite /= Void
			a_position_table_not_void: a_position_table /= Void
		local
			a_cursor: DS_LINKED_LIST_CURSOR [XM_NODE]
			a_child_element: XM_ELEMENT
			should_remove: BOOLEAN
		do
			expand_attribute_variables (a_composite)
			a_cursor := a_composite.new_cursor
			from
				a_cursor.start
			until
				a_cursor.after
			loop
				should_remove := False
				a_child_element ?= a_cursor.item
				if
					a_child_element /= Void
				then
					if
						should_strip_element (a_child_element, a_position_table)
					then
						should_remove := True
					else
						preprocess_composite (a_child_element, a_position_table)
					end
				end
				if
					should_remove
				then
					a_composite.remove_at_cursor (a_cursor)
				else
					a_cursor.forth
				end
			end
		end

feature {NONE} -- Implementation

	should_strip_element (an_element: XM_ELEMENT; a_position_table: XM_POSITION_TABLE): BOOLEAN is
			-- Does `an_element' contain an "if" attribute which evaluates
			-- to false or an "unless" attribute which evaluates to true?
		require
			an_element_not_void: an_element /= Void
			a_position_table_not_void: a_position_table /= Void
		local
			an_expression: UC_STRING
			is_if: BOOLEAN
		do
			if
				an_element.has_attribute_by_name (uc_if)
			then
				an_expression := an_element.attribute_by_name (uc_if).value
				is_if := True
			elseif
				an_element.has_attribute_by_name (uc_unless)
			then
				an_expression := an_element.attribute_by_name (uc_unless).value
			end

			if an_expression /= Void then
				if is_valid_expression (an_expression)
				then
					Result := is_expression_true (an_expression)
					if is_if then
						Result := not Result
					end
				else
					error_handler.report_invalid_expression_error (an_expression, a_position_table.item (an_element))
				end
			end
		end

	is_valid_expression (a_string: UC_STRING): BOOLEAN is
			-- Is expression `a_string' valid according to the syntax
			-- rules of expressions in "if" and "unless" expresssions?
		require
			a_string_not_void: a_string /= Void
		local
			an_equal_occurences: INTEGER
		do
			Result := True
			an_equal_occurences := a_string.occurrences ('=')
			if
				an_equal_occurences = 1
			then
				-- expression is a comparsion of two constants or variables
			elseif
				an_equal_occurences = 0
			then
				-- expression is a variable
				if
					a_string.count > 1 and then
					a_string.item (1) = '$'
				then
					if a_string.item (2) = '{' then
						if
							a_string.count > 3 and then
							a_string.item (a_string.count) = '}'
						then
						else
							-- missing closing curly brace
							Result := False
						end
					else
					end
				else
					-- non-comparing expression must be variable name
					Result := False
				end
			else
				-- At most one equal sign per expression allowed
				Result := False
			end
		end

	is_expression_true (a_string: UC_STRING): BOOLEAN is
			-- Does the expression `a_string' evaluate to `True'?
			-- Use `variables' to look up the values of variables
			-- occurring in `a_string'.
		require
			a_string_not_void: a_string /= Void
			is_valid_expression: is_valid_expression (a_string)
		local
			a_left_side: UC_STRING
			a_right_side: UC_STRING
			a_variable_name: UC_STRING
			equal_index: INTEGER
		do
			if
				a_string.occurrences ('=') > 0
			then
				-- expression is a comparsion of two constants or variables
				equal_index := a_string.index_of ('=', 1)
				a_left_side := new_unicode_string_from_utf8 (variables.expanded_variables (a_string.substring (1, equal_index - 1).to_utf8))
				if a_string.count > equal_index then
					a_right_side := new_unicode_string_from_utf8 (variables.expanded_variables ((a_string.substring (equal_index + 1, a_string.count).to_utf8)))
				else
					a_right_side := new_unicode_string ("")
				end
				Result := a_right_side.is_equal (a_left_side)
			else
				-- expression is a variable
				if
					a_string.count > 1 and then
					a_string.item (1) = '$'
				then
					if a_string.item (2) = '{' then
						if
							a_string.count > 3 and then
							a_string.item (a_string.count) = '}'
						then
							-- variable is of the form: ${FOO}
							a_variable_name := a_string.substring (3, a_string.count - 1)
						end
					else
						-- variable is of the form: $FOO
						a_variable_name := a_string.substring (2, a_string.count)
					end
				end
				check
					a_variable_name_not_void: a_variable_name /= Void
				end
				Result := variables.is_defined (a_variable_name.to_utf8)
			end
		end

	expand_attribute_variables (a_composite: XM_COMPOSITE) is
			-- Replace all variables with their values in all
			-- attributes of `a_composite'.
			-- Use `variables' to look up the values of all variables
			-- that occurre in the attributes.
		require
			a_composite_not_void: a_composite /= Void
		local
			an_attribute: XM_ATTRIBUTE
			a_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			an_uc_string: UC_STRING
		do
			a_cursor := a_composite.new_cursor
			from
				a_cursor.start
			until
				a_cursor.after
			loop
				an_attribute ?= a_cursor.item
				if
					an_attribute /= Void
				then
					an_uc_string := new_unicode_string_from_utf8 (variables.expanded_variables (an_attribute.value.to_utf8))
					an_attribute.set_value (an_uc_string)
				end
				a_cursor.forth
			end
		end

invariant

	variables_not_void: variables /= Void
	error_handler_not_void: error_handler /= Void

end
