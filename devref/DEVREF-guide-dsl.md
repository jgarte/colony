# DSL construction rules

When making a general purpose DSL, like define-texture-map, first, design the
class/struct/etc in memory representation of the information. Then, create a
programmatic API that both the engine and the appdev will use to
create/manipulate/destroy this information. Then create the "physical form" of
the DSL the appdev will write. This form contains all the detail that the DSL
form requires to specify all of the information. The DSL macro expander, often
in terms of actual CL functions and a relatively small defmacro that invokes
then, will convert the DSL to the programmatic API.  If the physical form of
the DSL is so complex that it has a "logical form" simplification, which is a
DSL that is highly common to write, doesn't require the full specification of
the physical form, and has slightly different syntax or semantics, then a
logical form expander may be written to convert the logical form to a physical
form.

- logical form sexp (simplistic/common: if any) macroexpands into a ->
- physical form sexp (full detail) macroexpands into a ->
- lambda closure of programmatic API sexp which at runtime evals into an ->
- in memory set of struct/class/etc objects.

The generated function may take arguments (like the context) whose variables
were specified in the DSL form so the symbol replacement works out correctly.

Unless there is a specific reason, the same programmatic API to the DSL's
concepts is used both by the engine and also exported so the appdev can use it
too.
