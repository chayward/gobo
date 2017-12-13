note

	description:

		"ECF parsers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008-2017, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_ECF_PARSER

inherit

	ET_ECF_PARSER_SKELETON
		redefine
			make_with_factory
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

feature {NONE} -- Initialization

	make_with_factory (a_factory: like ast_factory; an_error_handler: like error_handler)
			-- Create a new ECF parser using `a_factory' as AST factory.
		do
			precursor (a_factory, an_error_handler)
			create parsed_libraries.make_map (10)
			parsed_libraries.set_key_equality_tester (case_insensitive_string_equality_tester)
			create parsed_dotnet_assemblies.make_map (10)
			parsed_dotnet_assemblies.set_key_equality_tester (string_equality_tester)
			create redirected_locations.make (10)
			redirected_locations.set_equality_tester (string_equality_tester)
			create {XM_EIFFEL_PARSER} xml_parser.make
			xml_parser.set_string_mode_mixed
				-- The parser will build a tree.
			create tree_pipe.make
			xml_parser.set_callbacks (tree_pipe.start)
			tree_pipe.tree.enable_position_table (xml_parser)
			create_library_parser (a_factory, an_error_handler)
		end

	create_library_parser (a_factory: like ast_factory; an_error_handler: like error_handler)
			-- Create `library_parser', or set it to `Current' in descendant class
			-- ET_ECF_LIBRARY_PARSER (otherwise we would recurse in
			-- `make_with_factory' forever).
		require
			a_factory_not_void: a_factory /= Void
			an_error_handler_not_void: an_error_handler /= Void
		do
			create library_parser.make_with_factory (a_factory, an_error_handler)
			library_parser.set_parsed_libraries (parsed_libraries)
			library_parser.set_parsed_dotnet_assemblies (parsed_dotnet_assemblies)
		ensure
			library_parser_created: library_parser /= Void
		end

feature -- Access

	parsed_libraries: DS_HASH_TABLE [ET_ECF_LIBRARY, STRING]
			-- Already parsed ECF libraries, indexed by UUID

	parsed_dotnet_assemblies: DS_HASH_TABLE [ET_ECF_DOTNET_ASSEMBLY, STRING]
			-- Already parsed .NET assemblies, indexed by filenames

	library_parser: ET_ECF_LIBRARY_PARSER
			-- Library Parser

feature -- Parsing

	parse_file (a_file: KI_CHARACTER_INPUT_STREAM)
			-- Parse ECF file `a_file'.
		require
			a_file_not_void: a_file /= Void
			a_file_open_read: a_file.is_open_read
		local
			l_root_name: STRING
			l_document: XM_DOCUMENT
			l_root_element: XM_ELEMENT
			l_position_table: detachable XM_POSITION_TABLE
			l_unknown_universe: ET_ECF_SYSTEM
			l_full_filename: STRING
			l_position: ET_COMPRESSED_POSITION
			l_xm_position: XM_POSITION
			l_message: STRING
			l_file: KL_TEXT_INPUT_FILE
			l_filename: STRING
		do
				-- Make sure that the filename of the ECF system is a canonical absolute pathname.
			l_full_filename := a_file.name
				-- Make sure that the directory separator symbol is the
				-- one of the current file system. We take advantage of
				-- the fact that `windows_file_system' accepts both '\'
				-- and '/' as directory separator.
			l_full_filename := file_system.pathname_from_file_system (l_full_filename, windows_file_system)
			l_full_filename := file_system.absolute_pathname (l_full_filename)
			l_full_filename := file_system.canonical_pathname (l_full_filename)
			xml_parser.parse_from_stream (a_file)
			if xml_parser.is_correct then
				if not tree_pipe.error.has_error then
					l_document := tree_pipe.document
					l_root_element := l_document.root_element
					l_root_name := l_root_element.name
					l_position_table := tree_pipe.tree.last_position_table
					if STRING_.same_case_insensitive (l_root_name, xml_system) then
						build_system_config (l_root_element, l_position_table, l_full_filename)
					elseif STRING_.same_case_insensitive (l_root_name, xml_redirection) then
						if not attached l_root_element.attribute_by_name (xml_location) as l_location_attribute then
							l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
							error_handler.report_eadg_error (element_name (l_root_element, l_position_table), l_unknown_universe)
						elseif l_location_attribute.value.is_empty then
							l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
							error_handler.report_eadh_error (attribute_name (l_location_attribute, l_position_table), l_unknown_universe)
						else
							l_filename := l_location_attribute.value
								-- Make sure that the filename of the redirected ECF is a canonical absolute pathname.
							l_filename := Execution_environment.interpreted_string (l_filename)
								-- Make sure that the directory separator symbol is the
								-- one of the current file system. We take advantage of
								-- the fact that `windows_file_system' accepts both '\'
								-- and '/' as directory separator.
							l_filename := file_system.pathname_from_file_system (l_filename, windows_file_system)
							if file_system.is_relative_pathname (l_filename) then
								l_filename := file_system.pathname (file_system.dirname (l_full_filename), l_filename)
							end
							l_filename := file_system.canonical_pathname (l_filename)
							if redirected_locations.has (l_filename) then
									-- Cycle in redirected ECF files.
									-- First, remove filenames which are not part of the cycle.
								from
									redirected_locations.start
								until
									string_equality_tester.test (redirected_locations.item_for_iteration, l_filename)
								loop
									redirected_locations.remove (redirected_locations.item_for_iteration)
								end
								l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
								error_handler.report_eadi_error (attribute_name (l_location_attribute, l_position_table), redirected_locations, l_unknown_universe)
							else
								redirected_locations.force_last (l_filename)
								create l_file.make (l_filename)
								l_file.open_read
								if l_file.is_open_read then
									parse_file (l_file)
									l_file.close
								else
									l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
									error_handler.report_eadf_error (attribute_name (l_location_attribute, l_position_table), l_filename, l_unknown_universe)
								end
							end
						end
						redirected_locations.wipe_out
					else
						l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
						error_handler.report_eabx_error (element_name (l_root_element, l_position_table), l_unknown_universe)
					end
				else
					l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
					create l_position.make (0, 0)
					l_message := tree_pipe.last_error
					error_handler.report_syntax_error (l_message, l_position, l_unknown_universe)
				end
			else
				l_unknown_universe := ast_factory.new_system ("*unknown*", l_full_filename)
				l_xm_position := xml_parser.position
				create l_position.make (l_xm_position.row, l_xm_position.column)
				l_message := xml_parser.last_error_description
				if l_message = Void then
					l_message := "XML syntax error"
				end
				error_handler.report_syntax_error (l_message, l_position, l_unknown_universe)
			end
		end

feature -- Setting

	set_parsed_libraries (a_libraries: like parsed_libraries)
			-- Set `parsed_libraries' to `a_libraries'.
		require
			a_libraries_not_void: a_libraries /= Void
			no_void_library: not a_libraries.has_void_item
		do
			parsed_libraries := a_libraries
		ensure
			parsed_libraries_set: parsed_libraries = a_libraries
		end

	set_parsed_dotnet_assemblies (a_dotnet_assemblies: like parsed_dotnet_assemblies)
			-- Set `parsed_dotnet_assemblies' to `a_dotnet_assemblies'.
		require
			a_dotnet_assemblies_not_void: a_dotnet_assemblies /= Void
			no_void_dotnet_assembly: not a_dotnet_assemblies.has_void_item
		do
			parsed_dotnet_assemblies := a_dotnet_assemblies
		ensure
			parsed_dotnet_assemblies_set: parsed_dotnet_assemblies = a_dotnet_assemblies
		end

feature {NONE} -- Element change

	build_system_config (an_element: XM_ELEMENT; a_position_table: detachable XM_POSITION_TABLE; a_filename: STRING)
			-- Build system config from `an_element'.
		require
			an_element_not_void: an_element /= Void
			is_system: STRING_.same_case_insensitive (an_element.name, xml_system)
			a_filename_not_void: a_filename /= Void
		deferred
		end

feature {NONE} -- Implementation

	xml_parser: XM_PARSER
			-- XML parser

	tree_pipe: XM_TREE_CALLBACKS_PIPE
			-- Tree generating callbacks

	redirected_locations: DS_HASH_SET [STRING]
			-- Locations of redirected ECF files,
			-- used to detect cycles

invariant

	xml_parser_not_void: xml_parser /= Void
	tree_pipe_not_void: tree_pipe /= Void
	position_table_enabled: tree_pipe.tree.is_position_table_enabled
	redirected_locations_not_void: redirected_locations /= Void
	no_void_redirected_location: not redirected_locations.has_void

end
