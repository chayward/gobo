indexing

	description:

		"Objects that test for a match against nodes with a specific  content-type"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XPATH_CONTENT_TYPE_TEST

inherit

	XM_XPATH_NODE_TEST
		redefine
			node_kind
		end

creation

	make

feature {NONE} -- Initialization

	make (a_node_kind: INTEGER_8; a_type: XM_XPATH_SCHEMA_TYPE) is
		require
			valid_node_type: a_node_kind = Element_node or else a_node_kind = Attribute_node
			valid_type: a_type /= Void
		do
			node_kind := a_node_kind
			content_type := a_type.fingerprint
			original_text := a_type.description
		ensure
			node_kind_set: node_kind = a_node_kind
			content_type_set: content_type = a_type.fingerprint
			original_text_set: original_text = a_type.description
		end

feature -- Access

	node_kind: INTEGER_8
			-- Type of nodes to which this pattern applies

	node_kind_mask: INTEGER is
			-- Mask of types of nodes matched
		do
			Result := 1 |<< node_kind
		end

feature -- Status report

	allows_text_nodes: BOOLEAN is
			-- Does this node test allow text nodes?
		do
			Result := False
		end
	
feature -- Matching

	matches_node (a_node_kind: INTEGER; a_name_code: INTEGER; a_node_type: INTEGER): BOOLEAN is
			-- Is this node test satisfied by a given node?
		do
			if node_kind /= a_node_kind then
				Result := False
			elseif a_node_type = content_type then
				Result := True
			else
				Result := False
			end
		end

feature {NONE} -- Implementation

	content_type: INTEGER
			-- Required content type


end
