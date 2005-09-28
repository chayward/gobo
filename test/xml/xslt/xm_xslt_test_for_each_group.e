indexing

	description:

		"Test xs:for-each-group"

	library: "Gobo Eiffel XSLT test suite"
	copyright: "Copyright (c) 2005, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_XSLT_TEST_FOR_EACH_GROUP

inherit

	TS_TEST_CASE

	KL_IMPORTED_STRING_ROUTINES

	XM_XPATH_SHARED_CONFORMANCE

	XM_XSLT_CONFIGURATION_CONSTANTS

	XM_XPATH_SHARED_NAME_POOL

	XM_RESOLVER_FACTORY
	
feature

	test_grouping_nodes_based_on_common_values is
			-- Test group-by, and simplified stylesheet.
		local
			a_stylesheet_compiler: XM_XSLT_STYLESHEET_COMPILER
			a_configuration: XM_XSLT_CONFIGURATION
			a_transformer: XM_XSLT_TRANSFORMER
			a_uri_source, another_uri_source: XM_XSLT_URI_SOURCE
			an_output: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
		do
			conformance.set_basic_xslt_processor
			create a_configuration.make_with_defaults
			a_configuration.set_line_numbering (True)
			a_configuration.use_tiny_tree_model (True)
			create a_stylesheet_compiler.make (a_configuration)
			create a_uri_source.make ("./data/group_by_one.xsl")
			a_stylesheet_compiler.prepare (a_uri_source)
			assert ("Stylesheet compiled without errors", not a_stylesheet_compiler.load_stylesheet_module_failed)
			assert ("Stylesheet not void", a_stylesheet_compiler.last_loaded_module /= Void)
			a_transformer := a_stylesheet_compiler.new_transformer
			assert ("transformer", a_transformer /= Void)
			create another_uri_source.make ("./data/cities.xml")
			create an_output
			an_output.set_output_to_string
			create a_result.make (an_output, "string:")
			a_transformer.transform (another_uri_source, a_result)
			assert ("Transform successful", not a_transformer.is_error)
			assert ("Correct result", STRING_.same_string (an_output.last_output.out, expected_result_string_one))
		end

	test_grouping_starting_with is
			-- Test group-starting-with, and simplified stylesheet.
		local
			a_stylesheet_compiler: XM_XSLT_STYLESHEET_COMPILER
			a_configuration: XM_XSLT_CONFIGURATION
			a_transformer: XM_XSLT_TRANSFORMER
			a_uri_source, another_uri_source: XM_XSLT_URI_SOURCE
			an_output: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
		do
			conformance.set_basic_xslt_processor
			create a_configuration.make_with_defaults
			a_configuration.set_line_numbering (True)
			a_configuration.use_tiny_tree_model (True)
			create a_stylesheet_compiler.make (a_configuration)
			create a_uri_source.make ("./data/group_starting_with.xsl")
			a_stylesheet_compiler.prepare (a_uri_source)
			assert ("Stylesheet compiled without errors", not a_stylesheet_compiler.load_stylesheet_module_failed)
			assert ("Stylesheet not void", a_stylesheet_compiler.last_loaded_module /= Void)
			a_transformer := a_stylesheet_compiler.new_transformer
			assert ("transformer", a_transformer /= Void)
			create another_uri_source.make ("./data/xslt_intro.xml")
			create an_output
			an_output.set_output_to_string
			create a_result.make (an_output, "string:")
			a_transformer.transform (another_uri_source, a_result)
			assert ("Transform successful", not a_transformer.is_error)
			assert ("Correct result", STRING_.same_string (an_output.last_output.out, expected_result_string_two))
		end
	
	test_current_grouping_key is
			-- Test fn:current-grouping-key() and fn:current-group().
		local
			a_stylesheet_compiler: XM_XSLT_STYLESHEET_COMPILER
			a_configuration: XM_XSLT_CONFIGURATION
			a_transformer: XM_XSLT_TRANSFORMER
			a_uri_source, another_uri_source: XM_XSLT_URI_SOURCE
			an_output: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
		do
			conformance.set_basic_xslt_processor
			create a_configuration.make_with_defaults
			a_configuration.set_line_numbering (True)
			a_configuration.use_tiny_tree_model (True)
			create a_stylesheet_compiler.make (a_configuration)
			create a_uri_source.make ("./data/current_group.xsl")
			a_stylesheet_compiler.prepare (a_uri_source)
			assert ("Stylesheet compiled without errors", not a_stylesheet_compiler.load_stylesheet_module_failed)
			assert ("Stylesheet not void", a_stylesheet_compiler.last_loaded_module /= Void)
			a_transformer := a_stylesheet_compiler.new_transformer
			assert ("transformer", a_transformer /= Void)
			create another_uri_source.make ("./data/titles.xml")
			create an_output
			an_output.set_output_to_string
			create a_result.make (an_output, "string:")
			a_transformer.transform (another_uri_source, a_result)
			assert ("Transform successful", not a_transformer.is_error)
			assert ("Correct result", STRING_.same_string (an_output.last_output.out, expected_result_string_three))
		end
	
	test_group_adjacent is
			-- Test group-adjacent, fn:current-grouping-key() and fn:current-group().
		local
			a_stylesheet_compiler: XM_XSLT_STYLESHEET_COMPILER
			a_configuration: XM_XSLT_CONFIGURATION
			a_transformer: XM_XSLT_TRANSFORMER
			a_uri_source, another_uri_source: XM_XSLT_URI_SOURCE
			an_output: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
		do
			conformance.set_basic_xslt_processor
			create a_configuration.make_with_defaults
			a_configuration.set_line_numbering (True)
			a_configuration.use_tiny_tree_model (True)
			create a_stylesheet_compiler.make (a_configuration)
			create a_uri_source.make ("./data/group_adjacent.xsl")
			a_stylesheet_compiler.prepare (a_uri_source)
			assert ("Stylesheet compiled without errors", not a_stylesheet_compiler.load_stylesheet_module_failed)
			assert ("Stylesheet not void", a_stylesheet_compiler.last_loaded_module /= Void)
			a_transformer := a_stylesheet_compiler.new_transformer
			assert ("transformer", a_transformer /= Void)
			create another_uri_source.make ("./data/mobile.xml")
			create an_output
			an_output.set_output_to_string
			create a_result.make (an_output, "string:")
			a_transformer.transform (another_uri_source, a_result)
			assert ("Transform successful", not a_transformer.is_error)
			assert ("Correct result", STRING_.same_string (an_output.last_output.out, expected_result_string_four))
		end

	test_group_ending_with is
			-- Test group-ending-with and fn:current-group().
		local
			a_stylesheet_compiler: XM_XSLT_STYLESHEET_COMPILER
			a_configuration: XM_XSLT_CONFIGURATION
			a_transformer: XM_XSLT_TRANSFORMER
			a_uri_source, another_uri_source: XM_XSLT_URI_SOURCE
			an_output: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
		do
			conformance.set_basic_xslt_processor
			create a_configuration.make_with_defaults
			a_configuration.set_line_numbering (True)
			a_configuration.use_tiny_tree_model (True)
			create a_stylesheet_compiler.make (a_configuration)
			create a_uri_source.make ("./data/group_ending_with.xsl")
			a_stylesheet_compiler.prepare (a_uri_source)
			assert ("Stylesheet compiled without errors", not a_stylesheet_compiler.load_stylesheet_module_failed)
			assert ("Stylesheet not void", a_stylesheet_compiler.last_loaded_module /= Void)
			a_transformer := a_stylesheet_compiler.new_transformer
			assert ("transformer", a_transformer /= Void)
			create another_uri_source.make ("./data/continued.xml")
			create an_output
			an_output.set_output_to_string
			create a_result.make (an_output, "string:")
			a_transformer.transform (another_uri_source, a_result)
			assert ("Transform successful", not a_transformer.is_error)
			assert ("Correct result", STRING_.same_string (an_output.last_output.out, expected_result_string_five))
		end

	expected_result_string_one: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?><table><tr><th>Position</th><th>Country</th><th>City List</th><th>Population</th></tr><tr><td>1</td><td>Italia</td><td>Milano, Venezia</td><td/></tr><tr><td>2</td><td>France</td><td>Paris, Lyon</td><td/></tr><tr><td>3</td><td>Deutschland</td><td>M%%/252/nchen</td><td/></tr></table>"

	expected_result_string_two: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?><chapter><section title=%"Introduction%"><para>XSLT is used to write stylesheets.</para><para>XQuery is used to query XML databases.</para></section><section title=%"What is a stylesheet?%"><para>A stylesheet is an XML document used to define a transformation.</para><para>Stylesheets may be written in XSLT.</para><para>XSLT 2.0 introduces new grouping constructs.</para></section></chapter>"

	expected_result_string_three: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?><h2>Java</h2><p>A Beginner's Guide to Java</p><p>Using XML with Java</p><h2>XML</h2><p>Learning XML</p><p>Using XML with Java</p>"

	expected_result_string_four: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?><p>Do <em>not</em>:%
%%N    </p><ul>%
%%N    <li>talk,</li>%
%%N    <li>eat, or</li>%
%%N    <li>use your mobile telephone</li>%
%%N    </ul><p>%
%%N    while you are in the cinema.</p>"

    expected_result_string_five: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?><doc><pageset><page>Some text</page><page>More text</page><page>Yet more text</page></pageset><pageset><page>Some words</page><page>More words</page><page>Yet more words</page></pageset></doc>"

end
