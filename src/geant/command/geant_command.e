indexing

	description:

		"Geant commands"

	library:    "Gobo Eiffel Ant"
	author:     "Sven Ehrke <sven.ehrke@sven-ehrke.de>"
	copyright:  "Copyright (c) 2001, Sven Ehrke and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

deferred class GEANT_COMMAND

inherit

	DP_COMMAND
		undefine
			is_executable
		end

	GEANT_SHARED_PROPERTIES
		export
			{NONE} all
		end
	
	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		end

	KL_SHARED_EXCEPTIONS
		export
			{NONE} all
		end

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_project: GEANT_PROJECT) is
			-- Initialize command by setting `project' to `a_project'.
		require
			project_not_void: a_project /= Void
		do
			set_project (a_project)
		ensure
			project_set: project = a_project
		end

feature -- Status report

	exit_code: INTEGER
			-- Exit code of last execution

feature -- Access

	project: GEANT_PROJECT
			-- Project to which this target belongs

feature -- Setting

	set_project (a_project: like project) is
			-- Set `project' to `a_project'.
		do
			project := a_project
		ensure
			project_set: project = a_project
		end

	set_exit_code (a_exit_code: INTEGER) is
			-- Set `exit_code' to `a_exit_code'.
		do
			exit_code := a_exit_code
		ensure
			exit_code_set: exit_code = a_exit_code
		end

feature -- Output

	trace (a_message: STRING) is
			-- Write `a_message' to standard output unless `project.verbose' = False.
		require
			message_not_void: a_message /= Void
		do
			if project.verbose then
				std.output.put_string (a_message)
				std.output.flush
			end
		end

	log (a_message: STRING) is
			-- Write `a_message' to standard output.
		require
			message_not_void: a_message /= Void
		do
			std.output.put_string (a_message)
			std.output.flush
		end

feature {NONE} -- Implementation

	execute_shell (a_command: STRING) is
			-- Execute shell command `a_command'.
		require
			a_command_not_void: a_command /= Void
			a_command_not_empty: a_command.count > 0
		local
			shell_command: DP_SHELL_COMMAND
		do
			!! shell_command.make (a_command)
			shell_command.execute
			exit_code := shell_command.exit_code
		end

end -- class GEANT_COMMAND

