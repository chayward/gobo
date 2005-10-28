indexing

	description:

		"Objects that receive XPath events"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2003, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_XPATH_RECEIVER

inherit

	ANY

	XM_XPATH_RECEIVER_OPTIONS
		export {NONE} all end

	XM_XPATH_SHARED_NAME_POOL
		export {NONE} all end

	-- This is an interface to receive XML events.
	-- It is based on XM_CALLBACKS, XM_DTD_CALLBACKS and XM_DTD_ATTRIBUTE_CONTENT,
	-- but has additional events, and works with XM_XPATH_NAME_POOL.
	-- Namespaces and attributes are handled by separate events, and Schema types
	-- can be defined for elements and attributes.

	-- XM_XPATH_CONTENT_EMITTER is available to mediate between XM_CALLBACKS etc.,
	-- and implementations of this class.

feature -- Access

	system_id: STRING
			-- SYSTEM-id of the document

feature -- Ststus report

	is_open: BOOLEAN
			-- Has `open' been called yet?

	is_document_started: BOOLEAN
			-- Has `start_document' been called yet?

	is_name_code_ok_for_start_element (a_name_code: INTEGER): BOOLEAN is
			-- Is `a_name_code' valid for `start_element'?
		do

			-- This is redefined by receivers capable of skipping an element

			Result := a_name_code >= 0
		end

feature -- Events

	on_error (a_message: STRING) is
			-- Event producer detected an error.
		require
			not_void: a_message /= Void
		deferred
		end

	open is
			-- Notify start of event stream.
		require
			not_open: not is_open
		deferred
		ensure
			opened: is_open
		end
	
	start_document is
			-- Notify start of document node.
		require
			opened: is_open
			not_previously_started: not is_document_started
		deferred
		ensure
			document_started: is_document_started
		end

	set_unparsed_entity (a_name: STRING; a_system_id: STRING; a_public_id: STRING) is
			-- Notify an unparsed entity URI.
		require
			opened: is_open
			name_not_void: a_name /= Void
			system_id_not_void: a_system_id /= Void
			public_id_not_void: a_public_id /= Void
		deferred
		end

	start_element (a_name_code: INTEGER; a_type_code: INTEGER; properties: INTEGER) is
			-- Notify the start of an element.
		require
			opened: is_open
			valid_name_code: is_name_code_ok_for_start_element (a_name_code)
		deferred
		end

	notify_namespace (a_namespace_code: INTEGER; properties: INTEGER) is
			-- Notify a namespace.
			-- Namespaces are notified after the `start_element' event, and before
			--  any children for the element. The namespaces that are reported are only required
			--  to include those that are different from the parent element; however, duplicates may be reported.
			-- A namespace must not conflict with any namespaces already used for element or attribute names.
		require
			opened: is_open
			positive_namespace_code: a_namespace_code >= 0
		deferred
		end

	notify_attribute (a_name_code: INTEGER; a_type_code: INTEGER; a_value: STRING; properties: INTEGER) is
			-- Notify an attribute;
			-- Attributes are notified after the `start_element' event, and before any
			--  children. Namespaces and attributes may be intermingled
		require
			opened: is_open
			positive_name_code: a_name_code >= 0
			value_not_void: a_value /= Void
		deferred
		end

	start_content is
			-- Notify the start of the content, that is, the completion of all attributes and namespaces.
			-- Note that the initial receiver of output from XSLT instructions will not receive this event,
			--  it has to detect it itself. Note that this event is reported for every element even if it has
			--  no attributes, no namespaces, and no content.
		require
			opened: is_open
			element_open: True -- In general, we won't occur the overhead of maintaining a stack to prove this
		deferred
		end

	end_element is
			-- Notify the end of an element;
			-- The receiver must maintain a stack if it needs to know which
			--  element is ending.
		require
			opened: is_open
			element_open: True -- In general, we won't occur the overhead of maintaining a stack to prove this
		deferred
		end

	notify_characters (chars: STRING; properties: INTEGER) is
			-- Notify character data.
			-- Note that some receivers may require the character data to be
			--  sent in a single event, but in general this is not a requirement.
		require
			opened: is_open
			element_open: True -- In general, we won't occur the overhead of maintaining a stack to prove this
			data_not_void: chars /= Void
		deferred
		end

	notify_processing_instruction (a_name: STRING; a_data_string: STRING; properties: INTEGER) is
			-- Notify a processing instruction.
		require
			opened: is_open
			name_not_void: a_name /= Void
			data_not_void: a_data_string /= Void
		deferred
		end
	
	notify_comment (a_content_string: STRING; properties: INTEGER) is
			-- Notify a comment.
			-- Comments are only notified if they are outside the DTD.
		require
			opened: is_open
			content_not_void: a_content_string /= Void
		deferred
		end

	end_document is
			-- Notify end of document node.
		require
			opened: is_open
			document_started: is_document_started
		deferred
		ensure
			document_closed: not is_document_started
		end

	close is
			-- Notify end of event stream.
		require
			opened: is_open
		deferred
		ensure
			not_open: not is_open
		end

feature -- Element change

	set_system_id (a_system_id: STRING) is
			-- Set the system-id of the destination tree.
		require
			not_open: not is_open
			system_id_not_void: a_system_id /= Void
		deferred
		end

	set_document_locator (a_locator: XM_XPATH_LOCATOR) is
			-- Set the locator.
		require
			not_open: not is_open
			locator_not_void: a_locator /= Void
		deferred
		end

invariant

	system_id_not_void: system_id /= Void

end

