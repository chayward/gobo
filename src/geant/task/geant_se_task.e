indexing

	description:

		"Compilation tasks for SmallEiffel"

	library:    "Gobo Eiffel Ant"
	author:     "Sven Ehrke <sven.ehrke@sven-ehrke.de>"
	copyright:  "Copyright (c) 2001, Sven Ehrke and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"


class GEANT_SE_TASK

inherit

	GEANT_TASK
		rename
			make as task_make
		redefine
			command
		end

creation

	make

feature {NONE} -- Initialization

	make (a_project: GEANT_PROJECT; an_xml_element: GEANT_XML_ELEMENT) is
			-- Create a new task with information held in `an_element'.
		local
			a_value: STRING
		do
			!! command.make (a_project)
			task_make (command, an_xml_element)
			if has_uc_attribute (Ace_attribute_name) then
					-- ace_filename (optional)
				a_value := attribute_value_or_default (Ace_attribute_name.out, "")
				if a_value.count > 0 then
					command.set_ace_filename (a_value)
				end
			elseif has_uc_attribute (Clean_attribute_name) then
					-- clean:
				a_value := attribute_value_or_default (Clean_attribute_name.out, "")
				if a_value.count > 0 then
					command.set_clean (a_value)
				end
			else
					-- root_class:
				if has_uc_attribute (Root_class_attribute_name) then
					a_value := attribute_value (Root_class_attribute_name.out)
					if a_value.count > 0 then
						command.set_root_class (a_value)
					end
				end
					-- creation_procedure:
				if has_uc_attribute (Creation_procedure_attribute_name) then
					a_value := attribute_value (Creation_procedure_attribute_name.out)
					if a_value.count > 0 then
						command.set_creation_procedure (a_value)
					end
				end
					-- executable:
				if has_uc_attribute (Executable_attribute_name) then
					a_value := attribute_value (Executable_attribute_name.out)
					if a_value.count > 0 then
						command.set_executable (a_value)
					end
				end
					-- case_insensitive:
				if has_uc_attribute (Case_insensitive_attribute_name) then
					command.set_case_insensitive (uc_boolean_value (Case_insensitive_attribute_name))
				end
					-- no_style_warning:
				if has_uc_attribute (No_style_warning_attribute_name) then
					command.set_no_style_warning (uc_boolean_value (No_style_warning_attribute_name))
				end
			end
		end

feature -- Access

	command: GEANT_SE_COMMAND
			-- Compilation commands for SmallEiffel

feature {NONE} -- Constants

	Ace_attribute_name: UC_STRING is
			-- Name of xml attribute for "ace"
		once
			!! Result.make_from_string ("ace")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	Root_class_attribute_name: UC_STRING is
			-- Name of xml attribute for root_class
		once
			!! Result.make_from_string ("root_class")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	Creation_procedure_attribute_name: UC_STRING is
			-- Name of xml attribute for creation_procedure
		once
			!! Result.make_from_string ("creation_procedure")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	Executable_attribute_name: UC_STRING is
			-- Name of xml attribute for executable
		once
			!! Result.make_from_string ("executable")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	Case_insensitive_attribute_name: UC_STRING is
			-- Name of xml attribute for case_insensitive
		once
			!! Result.make_from_string ("case_insensitive")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	No_style_warning_attribute_name: UC_STRING is
			-- Name of xml attribute for no_style_warning
		once
			!! Result.make_from_string ("no_style_warning")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

	Clean_attribute_name: UC_STRING is
			-- Name of xml attribute for "clean"
		once
			!! Result.make_from_string ("clean")
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: not Result.empty
		end

end -- class GEANT_SE_TASK
