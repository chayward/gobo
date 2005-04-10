indexing
	description:

		"Elements whose name is not known at compile time"

	library: "Gobo Eiffel XSLT Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XSLT_COMPILED_ELEMENT

inherit

	XM_XSLT_ELEMENT_CONSTRUCTOR
		redefine
			simplify, analyze, sub_expressions, promote_instruction
		end

creation

	make

feature {NONE} -- Initialization

	make (an_executable: XM_XSLT_EXECUTABLE; an_element_name, a_namespace: XM_XPATH_EXPRESSION; a_namespace_context: XM_XSLT_NAMESPACE_CONTEXT;
			some_attribute_sets: DS_ARRAYED_LIST [XM_XSLT_COMPILED_ATTRIBUTE_SET]; a_schema_type: XM_XPATH_SCHEMA_TYPE; a_validation_action: INTEGER;
			inherit_namespaces: BOOLEAN; a_content: XM_XPATH_EXPRESSION) is
			-- Establish invariant.
		require
			executable_not_void: an_executable /= Void
			element_name_not_void: an_element_name /= Void
			namespace_or_namespace_context: a_namespace = Void implies a_namespace_context /= Void
			validation: a_validation_action >= Validation_strict  and then Validation_strip >= a_validation_action
			content_not_void: a_content /= Void
		do
			executable := an_executable
			element_name := an_element_name
			adopt_child_expression (element_name)
			namespace := a_namespace
			if namespace /= Void then adopt_child_expression (namespace) end
			namespace_context := a_namespace_context
			attribute_sets := some_attribute_sets
			validation_action := a_validation_action
			type := a_schema_type
			is_inherit_namespaces := inherit_namespaces
			content := a_content
			adopt_child_expression (content)
			compute_static_properties
			initialize
		ensure
			executable_set: executable = an_executable
			element_name_set: element_name = an_element_name
			attribute_sets_set: attribute_sets = some_attribute_sets
			namespace_set: namespace = a_namespace
			namespace_context_set: namespace_context = a_namespace_context
			validation_action_set: validation_action = a_validation_action
			type_set: type = a_schema_type
			is_inherit_namespaces_set: is_inherit_namespaces = inherit_namespaces
			content_set: content = a_content
		end

feature -- Access
	
	instruction_name: STRING is
			-- Name of instruction, for diagnostics
		do
			Result := "xsl:element"
		end

	sub_expressions: DS_ARRAYED_LIST [XM_XPATH_EXPRESSION] is
			-- Immediate sub-expressions
		do
			create Result.make (3)
			Result.set_equality_tester (expression_tester)
			Result.put (content, 1)
			Result.put (element_name, 2)
			if namespace /= Void then
				Result.put (namespace, 3)
			end
		end

	name_code (a_context: XM_XSLT_EVALUATION_CONTEXT): INTEGER is
			-- Name code;
			-- Not 100% pure as it may report an error.
		local
			a_name_value: XM_XPATH_ITEM
			a_string_value: XM_XPATH_STRING_VALUE
			a_uri, an_xml_prefix, a_local_name: STRING
			a_splitter: ST_SPLITTER
			qname_parts: DS_LIST [STRING]
			an_error: XM_XPATH_ERROR_VALUE 
		do
			element_name.evaluate_item (a_context)
			a_name_value := element_name.last_evaluated_item
			if a_name_value = Void or else a_name_value.is_error then -- empty sequence
				create an_error.make_from_string ("xsl:element has no 'name'", "","XTDE0820", Dynamic_error) 
				a_context.transformer.report_recoverable_error (an_error, Current)
				Result := -1
			else
				a_string_value ?= a_name_value
				check
					qname: a_string_value /= Void
				end
				create a_splitter.make
				a_splitter.set_separators (":")
				qname_parts := a_splitter.split (a_string_value.string_value)
				if qname_parts.count = 0 or else qname_parts.count > 2 then
					create an_error.make_from_string ("'name' attribute of xsl:element does not evaluate to a lexical QName.", "","XTDE0820", Dynamic_error) 
					a_context.transformer.report_recoverable_error (an_error, Current)
					Result := -1
				elseif qname_parts.count = 1 then
					a_local_name := qname_parts.item (1)
					an_xml_prefix := ""
				else
					a_local_name := qname_parts.item (2)
					an_xml_prefix := qname_parts.item (1)
				end
			end
			if Result /= -1 then
				if namespace = Void then
					a_uri := namespace_context.uri_for_defaulted_prefix (an_xml_prefix, True)
					if a_uri = Void then
						create an_error.make_from_string (STRING_.concat ("'name' attribute of xsl:element has an undeclared prefix: ", an_xml_prefix), "","XTDE0830", Dynamic_error) 
						a_context.transformer.report_recoverable_error (an_error, Current)
						Result := -1
						check False end
					end
				else
					namespace.evaluate_as_string (a_context)
					if namespace.last_evaluated_string.is_error then
						a_context.transformer.report_warning ("'namespace' attribute of xsl:element failed evaluation - using null namespace", Current)
						a_uri := ""
					else
						a_uri := namespace.last_evaluated_string.string_value
					end
					if a_uri.count = 0 then
						an_xml_prefix := ""
					end
					if STRING_.same_string (an_xml_prefix, "xmlns") then
						-- not legal, so:
						an_xml_prefix := "x-xmlns"
					end
				end
				if Result /= -1 then
					if shared_name_pool.is_name_code_allocated (an_xml_prefix, a_uri, a_local_name) then
						Result := shared_name_pool.name_code (an_xml_prefix, a_uri, a_local_name)
					else
						shared_name_pool.allocate_name (an_xml_prefix, a_uri, a_local_name)
						Result := shared_name_pool.last_name_code
					end
				end
			end
		end

feature -- Status report

	display (a_level: INTEGER) is
			-- Diagnostic print of expression structure to `std.error'
		local
			a_string: STRING
		do
			a_string := STRING_.appended_string (indentation (a_level), "element ")
			std.error.put_string (a_string)
			std.error.put_new_line
			a_string := STRING_.appended_string (indentation (a_level + 1), "name ")
			std.error.put_string (a_string)
			element_name.display (a_level + 2)
			std.error.put_new_line
			a_string := STRING_.appended_string (indentation (a_level + 1), "content ")
			std.error.put_string (a_string)
			content.display (a_level + 2)
		end


feature -- Optimization

	simplify is
			-- Perform context-independent static optimizations
		do
			element_name.simplify
			if element_name.was_expression_replaced then
				element_name := element_name.replacement_expression
				adopt_child_expression (element_name)
			end
			if namespace /= Void then
				namespace.simplify
				if namespace.was_expression_replaced then
					namespace := namespace.replacement_expression
					adopt_child_expression (namespace)
				end
			end
			Precursor
		end

	analyze (a_context: XM_XPATH_STATIC_CONTEXT) is
			-- Perform static analysis of `Current' and its subexpressions.
		local
			a_role: XM_XPATH_ROLE_LOCATOR
			a_type_checker: XM_XPATH_TYPE_CHECKER
			a_single_string_type: XM_XPATH_SEQUENCE_TYPE
		do
			element_name.analyze (a_context)
			if element_name.was_expression_replaced then
				element_name := element_name.replacement_expression
			end
			create a_role.make (Instruction_role, "xsl:element/name", 1)
			create a_type_checker
			create a_single_string_type.make_single_string
			a_type_checker.static_type_check (a_context, element_name, a_single_string_type, False, a_role)
			if a_type_checker.is_static_type_check_error then
				set_last_error_from_string (a_type_checker.static_type_check_error_message, Xpath_errors_uri, "XPTY0004", Type_error)
			else
				element_name := (a_type_checker.checked_expression)
				adopt_child_expression (element_name)
			end
			if namespace /= Void then
				namespace.analyze (a_context)
				if namespace.was_expression_replaced then
					namespace := namespace.replacement_expression
				end
				create a_role.make (Instruction_role, "xsl:element/namespace", 1)
				create a_type_checker
				a_type_checker.static_type_check (a_context, namespace, a_single_string_type, False, a_role)
				if a_type_checker.is_static_type_check_error then
					set_last_error_from_string (a_type_checker.static_type_check_error_message, Xpath_errors_uri, "XPTY0004", Type_error)
				else
					namespace := (a_type_checker.checked_expression)
					adopt_child_expression (namespace)
				end			
			end
			Precursor (a_context)
		end

	promote_instruction (an_offer: XM_XPATH_PROMOTION_OFFER) is
			-- Promote this instruction.
		do
			element_name.promote (an_offer)
			if element_name.was_expression_replaced then
				element_name := element_name.replacement_expression
				adopt_child_expression (element_name)
			end
			if namespace /= Void then
				namespace.promote (an_offer)
				if namespace.was_expression_replaced then
					namespace := namespace.replacement_expression
					adopt_child_expression (namespace)
				end
			end
			Precursor (an_offer)
		end

feature {XM_XSLT_ELEMENT_CREATOR} -- Local

	output_namespace_nodes (a_context: XM_XSLT_EVALUATION_CONTEXT; a_receiver: XM_XPATH_RECEIVER) is
			-- Output namespace nodes for the new element.
		do
			-- do_nothing
		end


feature {NONE} -- Implementation
	
	element_name: XM_XPATH_EXPRESSION
			-- Name
	
	namespace: XM_XPATH_EXPRESSION
			-- Namespace

	namespace_context: XM_XSLT_NAMESPACE_CONTEXT
			-- namespace context

invariant

	element_name_not_void: element_name /= Void
	namespace_or_namespace_context: namespace = Void implies namespace_context /= Void

end
	
