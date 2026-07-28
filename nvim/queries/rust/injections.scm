;; extends

(macro_invocation
    (scoped_identifier
        path: (identifier) @_path (#eq? @_path "sqlx")
        name: (identifier) @_name (#any-of? @_name "query" "query_as" "query_scalar")
    )
    (token_tree
        (raw_string_literal (string_content) @injection.content)
    )
    (#set! injection.language "sql")
)

(call_expression
  function: (scoped_identifier
              path: (identifier) @_path (#eq? @_path "sqlx")
              name: (identifier) @_name (#any-of? @_name "query" "query_as")
  )
  arguments: (arguments (raw_string_literal (string_content) @injection.content ))
  (#set! injection.language "sql")
)

(call_expression
  function: (generic_function
              function: (scoped_identifier
                          path: (identifier) @_path (#eq? @_path "sqlx")
                          name: (identifier) @_name (#eq? @_name "query_as"))
              type_arguments: (type_arguments (type_identifier) (type_identifier)))
  arguments: (arguments (raw_string_literal (string_content) @injection.content ))
  (#set! injection.language "sql")
)
