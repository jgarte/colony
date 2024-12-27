# Coding Guidelines

This is an ever evolving document.

- Common Lisp should:
  - be written in an 80 column format. fill-column is 79.
  - be indented via SLIME/SLY or a tool that indents the same way.
  - have no tabs in it. Literal tabs in strings are ok, but avoid if possible.
  - have all warnings when loading removed.
    ASDF is configured to convert warnings to errors when loading the engine.

- Markdown documentation should:
  - have a filename that starts with `DEVREF-`,
  - be 80 columns when possible, fill-column is 72.
  - have no tabs in it.
  - stick to this subset of syntax:
    - single backticks for paths, syntax datums, etc, etc,
    - foot-note style labeled links to all external URLS or relative paths,
    - code blocks indicating language,
    - basic list and indented list format (unordered and ordered).
  - use only the markup required to explain the information and no more.
