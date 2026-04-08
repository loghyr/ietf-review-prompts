# XDR Consistency and Extractability Patterns

These patterns apply to IETF drafts that embed XDR descriptions using
the extraction sentinel convention (lines prefixed with `/// `).

## Extraction Sentinel

The standard extraction shell script is:
  grep '^ *///' $* | sed 's?^ */// ??' | sed 's?^ *///$??'

Check that:
1. Every XDR line (type definitions, struct fields, enum values, union arms,
   constants, comments intended for the .x file) has the `/// ` sentinel.
2. Lines inside ~~~ xdr / ~~~ blocks that are intentionally NOT part of the
   extracted XDR (prose examples, non-normative illustrations) do NOT have
   the sentinel.
3. The extracted XDR, taken in document order, would produce a compilable
   .x file when appended to the base RFC XDR (e.g., RFC 7863 for NFSv4.2).

## Type Naming

For NFSv4 extension drafts:
- New types MUST end with `4` (e.g., `my_new_type4`, `MY_CONST4`).
- Enum values use ALL_CAPS with the type prefix
  (e.g., `MY_TYPE_VALUE_ONE` for `enum my_type4`).

### Field Prefix Convention

Procedure names are words separated by `_` (e.g., `EXCHANGE_RANGE`,
`COPY_NOTIFY`).  Struct field names are derived from the procedure
name as follows:

- **Arguments** (`OP_NAME4args`): take the first letter of each word
  in `OP_NAME`, lower-cased, and append `a_`.
  Example: `EXCHANGE_RANGE` -- words E, R -- prefix `era_`
  Fields: `era_src_stateid`, `era_dst_offset`, `era_count`

- **Responses** (`OP_NAME4res` / `OP_NAME4resok`): same first letters,
  append `r_`.
  Example: `EXCHANGE_RANGE` -- words E, R -- prefix `err_`
  Fields: `err_status`, `err_resok4`

Prefix collisions between different operations are expected and are
NOT a finding.  For example, `EXTRA_REVIEW` would also yield `era_`
and `err_` -- this is by design and is not an error.

Check:
- All fields within a struct share the same prefix.
- The args prefix ends with `a_`; the response prefix ends with `r_`.
- The prefix letters match the initial letters of the procedure name
  words (case-insensitive).

## Operation Completeness

For each `OP_NAME = N` in the opnum enum:
1. A `NAME4args` struct MUST be defined (or `void` in the argop union).
2. A `NAME4res` union or struct MUST be defined.
3. If `NAME4res` is a union, the `NFS4_OK` arm SHOULD have a `NAME4resok`
   struct (unless the success case carries no data, in which case `void`
   is correct).
4. Both must appear in the `nfs_argop4` and `nfs_resop4` dispatch unions
   (or equivalent).

## Dispatch Union Completeness

Check `nfs_argop4` and `nfs_resop4` (or the draft's equivalent):
- Every `OP_NAME` constant has a corresponding case arm.
- No case arm references a type that is not defined.
- The case arm type names match the defined struct/union names exactly
  (case-sensitive).

## Union Switch Correctness

For `union NAME4res switch (nfsstat4 xxx_status)`:
- The switch variable name (`xxx_status`) MUST match the field name
  used by callers to check the result status.
- The `NFS4_OK` arm should be `NAME4resok xxx_resok4` or `void`.
- A `default: void` arm is required if not all nfsstat4 values are
  listed explicitly.

## Consistency Between XDR and Prose

For each operation with an ARGUMENTS section:
- Every field in the XDR struct MUST be described in the prose
  (even if briefly).
- Field names in prose MUST match XDR field names exactly.
  "The cea_offset field..." must correspond to a field literally
  named `cea_offset` in the XDR.

For each operation with a RESULTS section:
- Same rules apply to result struct fields.
- If the operation can return specific non-NFS4_OK status codes,
  those SHOULD be listed in the DESCRIPTION or ERRORS subsection.

## Common XDR Mistakes

XDR-PAT-1: Missing `/// ` sentinel on a field line inside a struct.
  The struct compiles but the field is absent from the extracted XDR.

XDR-PAT-2: Sentinel present on a prose line inside a ~~~ xdr block.
  Produces garbage in the extracted XDR.

XDR-PAT-3: Type used in a field but defined later with no forward
  declaration.  XDR requires types to be defined before use (no
  forward references), unlike C.

XDR-PAT-4: Duplicate type name.  Two structs or enums with the same
  name cause a compile error in the extracted XDR.

XDR-PAT-5: `opaque X<>` used where `opaque X<MAX>` with a defined
  constant is more appropriate for wire-size bounding.

XDR-PAT-6: Union arms that reference resok structs from a different
  operation.  Each operation's resok struct is specific to that op.
