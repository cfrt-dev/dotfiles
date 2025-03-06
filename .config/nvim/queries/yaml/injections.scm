(block_node (block_mapping (block_mapping_pair
    key: (flow_node) @_key (#eq? @_key "content")
    value: (block_node)  @injection.content
    (#offset! @injection.content 1 0 0 -1)
    (#set! injection.language "dockerfile")
)))
