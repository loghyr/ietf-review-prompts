# idnits Submission Checks

The IETF datatracker runs `idnits` on every submitted draft.  Errors
block submission; warnings and comments appear in the review.  This
pattern file checks the markdown source for conditions that produce
idnits findings in the rendered text output.

## What idnits checks

idnits validates the rendered plain-text output (`.txt`), not the
markdown source.  However, most idnits findings trace back to specific
patterns in the source.  The reviewer should flag source-level patterns
that are known to produce idnits findings.

## Checks

### CHECK 1: Non-ASCII characters

Scan the markdown source for any characters outside the printable ASCII
range (U+0020 through U+007E, plus tab and newline).  Common offenders:

- Curly quotes: `\u2018`, `\u2019`, `\u201C`, `\u201D`
  (use straight quotes `'` and `"` instead)
- Em dash: `\u2014` (use `--` instead)
- En dash: `\u2013` (use `-` instead)
- Ellipsis: `\u2026` (use `...` instead)
- Non-breaking space: `\u00A0` (use regular space)
- Accented characters in author names or references (acceptable in
  kramdown-rfc but flagged by idnits)

Note: kramdown-rfc `{::include}` may pull in files with non-ASCII.
Check included files too.

For each non-ASCII character found, report:
- The line number
- The character and its Unicode code point
- Whether it is in prose (fixable) or in an author name / reference
  title (acceptable but will be flagged)

### CHECK 2: Long lines in code blocks and tables

Lines inside fenced code blocks (`~~~`, `` ``` ``), ASCII art, and
tables are rendered verbatim.  If any such line exceeds 69 characters
(accounting for the 3-character indent that xml2rfc adds), it will
appear as a long line in the rendered output.

Scan all content inside:
- `~~~ xdr`, `~~~ ascii-art`, or any fenced block
- Table rows (lines starting with `|`)
- Lines with `///` XDR extraction sentinels

Flag any line exceeding 69 characters of content (excluding leading
whitespace that is structural markdown indentation).

### CHECK 3: Abstract length

idnits warns if the abstract exceeds 20 lines in the rendered output.
Check the `abstract:` field in the YAML front matter.  If it exceeds
roughly 15 lines of 72-character text, flag it.

### CHECK 4: Required boilerplate

kramdown-rfc handles most boilerplate automatically via
`{::boilerplate bcp14-tagged}` and the `ipr:` front matter field.
Verify these are present:

- `ipr:` is set in front matter (typically `trust200902`)
- If BCP 14 key words are used, `{::boilerplate bcp14-tagged}` is present
- `category:` is set (`std`, `bcp`, `info`, `exp`)
- `docname:` is set and follows the `draft-*-NN` pattern

### CHECK 5: Reference completeness

idnits checks that every `[RFCXXXX]` citation in the text has a
matching entry in the references section, and vice versa.  In
kramdown-rfc, this means every `{{RFCXXXX}}` or `{{I-D.name}}` has a
corresponding entry in the `normative:` or `informative:` block of the
YAML front matter.

This overlaps with TASK 3 (Cross-References) in review-core.md but
is specifically about what idnits will flag.

## Common idnits mistakes

1. **XDR extraction lines with long type names**: `///` lines often
   exceed 69 chars when struct definitions have long field names.
   Fix: break the line or shorten the field name.

2. **ASCII art diagrams**: network diagrams and packet formats are
   often exactly 69-72 chars wide.  The xml2rfc 3-char indent pushes
   them over.  Fix: keep ASCII art to 66 characters wide.

3. **Table columns**: markdown tables with many columns or long cell
   values.  Fix: abbreviate or split the table.

4. **Author names with diacritics**: e.g., `Muller` for `M\u00FCller`.
   idnits flags these but they are often correct and acceptable.

5. **Missing `docname:` version suffix**: `docname:` must end with
   `-NN` (e.g., `-03`), not just the base name.
