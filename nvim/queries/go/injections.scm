;; extends

(short_var_declaration
  left: (expression_list (identifier) @_left (#eq? @_left "query"))
  right: (expression_list (interpreted_string_literal (interpreted_string_literal_content) @injection.content))
  (#set! injection.language "sql")
)
