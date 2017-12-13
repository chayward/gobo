note

	description:

		"ECF error handlers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006-2017, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

class ET_ECF_ERROR_HANDLER

inherit

	UT_ERROR_HANDLER
		redefine
			report_error_message
		end

create

	make_standard, make_null

feature -- Status report

	has_error: BOOLEAN
			-- Has an error been reported?
		do
			Result := (error_count > 0)
		end

feature -- Measurement

	error_count: INTEGER
			-- Number of errors reported so far

feature -- Syntax error

	report_syntax_error (a_message: STRING; a_position: ET_POSITION; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report an XML syntax error.
		require
			a_message_not_void: a_message /= Void
			a_position_not_void: a_position /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_syntax (a_message, a_position, a_universe)
			report_error (l_error)
		end

feature -- Reporting errors

	report_eaae_error (a_value_attribute_name, a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAE error: cannot have both value and excluded_value in build condition.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaae (a_value_attribute_name, a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaaf_error (a_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAF error: the value in build condition is empty.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaaf (a_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaag_error (a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAG error: the excluded value in build condition is empty.
		require
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaag (a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaah_error (a_build_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAH error: value or excluded value missing in build condition.
		require
			a_build_element_name_not_void: a_build_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaah (a_build_element_name, a_universe)
			report_error (l_error)
		end

	report_eaan_error (a_custom_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAN error: the name of the custom condition is missing.
		require
			a_custom_element_name_not_void: a_custom_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaan (a_custom_element_name, a_universe)
			report_error (l_error)
		end

	report_eaao_error (a_name_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAO error: the name of the custom condition is empty.
		require
			a_name_attribute_name_not_void: a_name_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaao (a_name_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaap_error (a_value_attribute_name, a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAP error: cannot have both value and excluded_value in custom condition.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaap (a_value_attribute_name, a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaaq_error (a_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAQ error: the value in custom condition is empty.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaaq (a_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaar_error (a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAR error: the excluded value in custom condition is empty.
		require
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaar (a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaas_error (a_custom_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAS error: value or excluded value missing in custom condition.
		require
			a_custom_element_name_not_void: a_custom_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaas (a_custom_element_name, a_universe)
			report_error (l_error)
		end

	report_eaat_error (a_dotnet_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAT error: the value of the dotnet condition is missing.
		require
			a_dotnet_element_name_not_void: a_dotnet_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaat (a_dotnet_element_name, a_universe)
			report_error (l_error)
		end

	report_eaau_error (a_value_attribute_name: ET_IDENTIFIER; a_value_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAU error: the value attribute of the dotnet condition should be a boolean.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_value_value_not_void: a_value_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaau (a_value_attribute_name, a_value_value, a_universe)
			report_error (l_error)
		end

	report_eaav_error (a_dynamic_runtime_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAV error: the value of the dynamic_runtime condition is missing.
		require
			a_dynamic_runtime_element_name_not_void: a_dynamic_runtime_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaav (a_dynamic_runtime_element_name, a_universe)
			report_error (l_error)
		end

	report_eaaw_error (a_value_attribute_name: ET_IDENTIFIER; a_value_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAW error: the value attribute of the dynamic_runtime condition should be a boolean.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_value_value_not_void: a_value_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaaw (a_value_attribute_name, a_value_value, a_universe)
			report_error (l_error)
		end

	report_eaax_error (a_multithreaded_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAX error: the value of the multithreaded condition is missing.
		require
			a_multithreaded_element_name_not_void: a_multithreaded_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaax (a_multithreaded_element_name, a_universe)
			report_error (l_error)
		end

	report_eaay_error (a_value_attribute_name: ET_IDENTIFIER; a_value_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAY error: the value attribute of the multithreaded condition should be a boolean.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_value_value_not_void: a_value_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaay (a_value_attribute_name, a_value_value, a_universe)
			report_error (l_error)
		end

	report_eaaz_error (a_value_attribute_name, a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EAAZ error: cannot have both value and excluded_value in platform condition.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaaz (a_value_attribute_name, a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eaba_error (a_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABA error: the value in platform condition is empty.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaba (a_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eabb_error (a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABB error: the excluded value in platform condition is empty.
		require
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabb (a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eabc_error (a_platform_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABC error: value or excluded value missing in platform condition.
		require
			a_platform_element_name_not_void: a_platform_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabc (a_platform_element_name, a_universe)
			report_error (l_error)
		end

	report_eabf_error (a_min_attribute_name: ET_IDENTIFIER; a_min_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABF error: wrong format for min attribute in version condition.
			-- It should be of the form "N.N.N.N".
		require
			a_min_attribute_name_not_void: a_min_attribute_name /= Void
			a_min_value_not_void: a_min_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabf (a_min_attribute_name, a_min_value, a_universe)
			report_error (l_error)
		end

	report_eabg_error (a_max_attribute_name: ET_IDENTIFIER; a_max_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABG error: wrong format for max attribute in version condition.
			-- It should be of the form "N.N.N.N".
		require
			a_max_attribute_name_not_void: a_max_attribute_name /= Void
			a_max_value_not_void: a_max_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabg (a_max_attribute_name, a_max_value, a_universe)
			report_error (l_error)
		end

	report_eabh_error (a_min_attribute_name: ET_IDENTIFIER; a_min_value: STRING; a_max_attribute_name: ET_IDENTIFIER; a_max_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABH error: the max value should be greater than
			-- or equal to the min value in version condition.
		require
			a_min_attribute_name_not_void: a_min_attribute_name /= Void
			a_min_value_not_void: a_min_value /= Void
			a_max_attribute_name_not_void: a_max_attribute_name /= Void
			a_max_value_not_void: a_max_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabh (a_min_attribute_name, a_min_value, a_max_attribute_name, a_max_value, a_universe)
			report_error (l_error)
		end

	report_eabi_error (a_version_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABI error: the type of the version condition is missing.
		require
			a_version_element_name_not_void: a_version_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabi (a_version_element_name, a_universe)
			report_error (l_error)
		end

	report_eabj_error (a_type_attribute_name: ET_IDENTIFIER; a_type_value: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABJ error: the type of the version condition should be either "compiler" or" msil_clr".
		require
			a_type_attribute_name_not_void: a_type_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabj (a_type_attribute_name, a_type_value, a_universe)
			report_error (l_error)
		end

	report_eabv_error (a_location_value: ET_IDENTIFIER; a_filename: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABV error: cannot open library ECF file `a_filename'.
		require
			a_location_value_not_void: a_location_value /= Void
			a_filename_not_void: a_filename /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabv (a_location_value, a_filename, a_universe)
			report_error (l_error)
		end

	report_eabw_error (a_location_value: ET_IDENTIFIER; a_filename: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABW error: no library target specified in library ECF file.
		require
			a_location_value_not_void: a_location_value /= Void
			a_filename_not_void: a_filename /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabw (a_location_value, a_filename, a_universe)
			report_error (l_error)
		end

	report_eabx_error (a_root_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABX error: the root element of an ECF file should be <system>.
		require
			a_root_element_name_not_void: a_root_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eabx (a_root_element_name, a_universe)
			report_error (l_error)
		end

	report_eaby_error (a_system_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EABY error: no target found in ECF file.
		require
			a_system_element_name_not_void: a_system_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eaby (a_system_element_name, a_universe)
			report_error (l_error)
		end

	report_eadb_error (a_value_attribute_name, a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADB error: cannot have both value and excluded_value in concurrency condition.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadb (a_value_attribute_name, a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eadc_error (a_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADC error: the value in concurrency condition is empty.
		require
			a_value_attribute_name_not_void: a_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadc (a_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eadd_error (a_excluded_value_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADD error: the excluded value in concurrency condition is empty.
		require
			a_excluded_value_attribute_name_not_void: a_excluded_value_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadd (a_excluded_value_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eade_error (a_platform_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADE error: value or excluded value missing in platform condition.
		require
			a_platform_element_name_not_void: a_platform_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eade (a_platform_element_name, a_universe)
			report_error (l_error)
		end

	report_eadf_error (a_location_value: ET_IDENTIFIER; a_filename: STRING; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADF error: cannot open redirected ECF file `a_filename'.
		require
			a_location_value_not_void: a_location_value /= Void
			a_filename_not_void: a_filename /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadf (a_location_value, a_filename, a_universe)
			report_error (l_error)
		end

	report_eadg_error (a_redirection_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADG error: the location of the redirected ECF is missing.
		require
			a_redirection_element_name_not_void: a_redirection_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadg (a_redirection_element_name, a_universe)
			report_error (l_error)
		end

	report_eadh_error (a_location_attribute_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADH error: the filename of the redirected ECF is empty.
		require
			a_location_attribute_name_not_void: a_location_attribute_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadh (a_location_attribute_name, a_universe)
			report_error (l_error)
		end

	report_eadi_error (a_location_attribute_name: ET_IDENTIFIER; a_cycle: DS_HASH_SET [STRING]; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADI error: cycle in ECF file redirections.
		require
			a_location_attribute_name_not_void: a_location_attribute_name /= Void
			a_cycle_not_void: a_cycle /= Void
			a_cycle_not_void: not a_cycle.is_empty
			no_void_filename: not a_cycle.has_void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadi (a_location_attribute_name, a_cycle, a_universe)
			report_error (l_error)
		end

	report_eadp_error (a_capability_name: STRING; a_capability_value: STRING; a_library_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADP error: value `a_capability_value' for capability `a_capability_name'
			-- (supported by `a_universe') is not supported by library `a_library_name'.
		require
			a_capability_name_not_void: a_capability_name /= Void
			a_capability_value_not_void: a_capability_value /= Void
			a_library_name_not_void: a_library_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadp (a_capability_name, a_capability_value, a_library_name, a_universe)
			report_error (l_error)
		end

	report_eadq_error (a_capability_name: STRING; a_capability_value: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADQ error: value `a_capability_value' for capability `a_capability_name'
			-- is not supported by current target in `a_universe'.
		require
			a_capability_name_not_void: a_capability_name /= Void
			a_capability_value_not_void: a_capability_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadq (a_capability_name, a_capability_value, a_universe)
			report_error (l_error)
		end

	report_eadr_error (a_extends_value: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADR error: parent target `a_extends_value' is
			-- not known in `a_universe'.
		require
			a_extends_value_not_void: a_extends_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eadr (a_extends_value, a_universe)
			report_error (l_error)
		end

	report_eads_error (a_capability_name: STRING; a_capability_value: STRING; a_parent_target_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EADS error: value `a_capability_value' for capability `a_capability_name'
			-- (supported by current target) is not supported by parent target `a_parent_target_name'.
		require
			a_capability_name_not_void: a_capability_name /= Void
			a_capability_value_not_void: a_capability_value /= Void
			a_parent_target_name_not_void: a_parent_target_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eads (a_capability_name, a_capability_value, a_parent_target_name, a_universe)
			report_error (l_error)
		end

	report_eatb_error (a_attribute_name, a_attribute_value, a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATB error: attribute `a_attribute_name' with value
			-- `a_attribute_value' in element `a_element_name' should be a boolean.
			--
			-- EATB: Ecf ATtribute Boolean
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_attribute_value_not_void: a_attribute_value /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eatb (a_attribute_name, a_attribute_value, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eatd_error (a_attribute_name, a_attribute_value, a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATD error: attribute `a_attribute_name' with value
			-- `a_attribute_value' already appears in another element `a_element_name'.
			--
			-- EATD: Ecf ATtribute Duplicated
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_attribute_value_not_void: a_attribute_value /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eatd (a_attribute_name, a_attribute_value, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eate_error (a_attribute_name, a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATE error: attribute `a_attribute_name' is empty in element `a_element_name'.
			--
			-- EATE: Ecf ATtribute Empty
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eate (a_attribute_name, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eati_error (a_attribute_name, a_attribute_value, a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATI error: attribute `a_attribute_name' with value
			-- `a_attribute_value' in element `a_element_name' should be
			-- an unsigned integer.
			--
			-- EATI: Ecf ATtribute unsigned Integer
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_attribute_value_not_void: a_attribute_value /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eati (a_attribute_name, a_attribute_value, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eatm_error (a_attribute_name: STRING; a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATM error: attribute `a_attribute_name' is missing in element `a_element_name'.
			--
			-- EATM: Ecf ATtribute Missing
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eatm (a_attribute_name, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eats_error (a_attribute_name: STRING; a_other_attribute_name, a_element_name: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report EATS error: attribute `a_attribute_name' is missing
			-- in element `a_element_name' when `a_other_attribute_name' is specified.
			--
			-- EATS: Ecf ATtribute miSsing
		require
			a_attribute_name_not_void: a_attribute_name /= Void
			a_other_attribute_name_not_void: a_other_attribute_name /= Void
			a_element_name_not_void: a_element_name /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eats (a_attribute_name, a_other_attribute_name, a_element_name, a_universe)
			report_error (l_error)
		end

	report_eltm_error (a_library_target_attribute_name, a_library_target_attribute_value: ET_IDENTIFIER; a_universe: ET_ECF_INTERNAL_UNIVERSE)
			-- Report ELTM error: the name of library target is not the name of an existing target.
			--
			-- ELTM: Ecf Library Target Missing
		require
			a_library_target_attribute_name_not_void: a_library_target_attribute_name /= Void
			aa_library_target_attribute_value_not_void: a_library_target_attribute_value /= Void
			a_universe_not_void: a_universe /= Void
		local
			l_error: ET_ECF_ERROR
		do
			create l_error.make_eltm (a_library_target_attribute_name, a_library_target_attribute_value, a_universe)
			report_error (l_error)
		end

feature -- Reporting

	report_error_message (an_error: STRING)
			-- Report `an_error'.
		do
			error_count := error_count + 1
			precursor (an_error)
		end

end
