# idnits Submission Checks

The IETF datatracker runs `idnits` on every submitted draft.  Errors
block submission; warnings and comments appear in the review.

## Automated Check: Run idnits Locally

Before doing source-level analysis, attempt to run idnits via the
project's build system.  This gives authoritative results against the
rendered output rather than heuristic guesses from the source.

### Detection

Look for Martin Thomson's i-d-template:

1. Check if `Makefile` exists in the draft directory
2. Check if it includes `lib/main.mk` (the i-d-template pattern)
3. If `lib/` does not exist, check for `.gitmodules` referencing
   `i-d-template` — if found, run `git submodule update --init`

Other Makefile patterns (e.g., standalone xml2rfc Makefiles) may also
have an `idnits` target.  Check with `grep -q idnits Makefile`.

### Execution

If an i-d-template Makefile is detected:

```bash
# Build the text output and run idnits
make idnits 2>&1
```

If `make idnits` succeeds, parse its output for errors (`**`), flaws
(`~~`), warnings (`==`), and comments (`--`).  Report each as an
IDNITS finding with the severity level.

If `make idnits` fails (missing dependencies, npm not installed, etc.),
fall back to source-level analysis (the checks below).

### Lint checks

i-d-template also provides:

```bash
make lint 2>&1
```

This checks whitespace, docname consistency, and default branch naming.
Run it if available and report findings.

### When tools are not available

If the Makefile is absent or the build fails, fall back to the
source-level heuristic checks below.  Prefix findings with
"(source-level heuristic)" to distinguish them from authoritative
idnits output.

---

## Source-Level Heuristic Checks (fallback)

These checks analyze the markdown source for patterns that are known
to produce idnits findings in the rendered output.  They are less
accurate than running idnits directly.

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
