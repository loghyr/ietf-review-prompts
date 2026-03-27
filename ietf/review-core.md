# IETF Internet-Draft Review Protocol

You are performing a thorough review of an IETF Internet-Draft.  This is not
a quick sanity check — it is a systematic analysis of correctness, completeness,
and standards compliance.

## Analysis Philosophy

Assume the draft has issues.  Every normative statement, cross-reference,
XDR definition, and IANA registration must be verified.  Flag anything
ambiguous, inconsistent, or incomplete.

## FILE LOADING INSTRUCTIONS

### Core Files (ALWAYS LOAD FIRST)
1. `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/rfc2119.md` — normative language rules
2. `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/iana.md` — IANA completeness rules
3. `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/security.md` — security coverage rules

### Conditional Files
- If the draft contains XDR (look for `~~~ xdr` or `/// ` lines):
  load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/xdr.md`

### Always Load (submission readiness)
4. `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/idnits.md` — submission nits

---

## TASK 0: Identify the Draft

Read the draft front matter and opening sections.  Record:

- Document name (docname)
- Category (std, bcp, info, exp)
- Abstract — one sentence summary of what this draft does
- Normative references listed
- Whether XDR is present

Output:
```
DRAFT: <docname>
CATEGORY: <category>
ABSTRACT SUMMARY: <one sentence>
XDR PRESENT: yes/no
```

---

## TASK 1: Document Structure

Check that the following sections are present and non-empty:

1. **Introduction** — describes the problem and what the document does
2. **Requirements Language** — BCP 14 boilerplate (exact wording per RFC 8174)
3. **Definitions / Terminology** — any new terms defined (optional but check)
4. **Security Considerations** — non-empty; see patterns/security.md
5. **IANA Considerations** — non-empty if new constants/registries; see patterns/iana.md
6. **Normative References** — present and complete
7. **Informative References** — present if cited

Flag any section that is present but contains only a placeholder or
editorial note (`<cref>`, "TODO", "TBD", "to be written", etc.).

Output each finding as:
```
STRUCTURE-N: <section name> — <issue>
```

---

## TASK 2: RFC 2119 / BCP 14 Normative Language

Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/rfc2119.md` and apply all checks.

For each violation, record:
- Location (section name or line context)
- The offending text
- The correct form

Output each finding as:
```
RFC2119-N: <location> — <issue>
```

---

## TASK 3: Cross-References

Check every internal cross-reference in the draft:

1. For each `{{sec-X}}`, `{{fig-X}}`, `{{tbl-X}}` reference: verify the
   corresponding `{#sec-X}`, `{#fig-X}`, `{#tbl-X}` anchor exists in the draft.

2. For each `{{RFCXXXX}}` or `{{I-D.name}}` citation: verify it appears in
   either the normative or informative references block in the front matter.
   - Citations used in normative prose (procedures, requirements) MUST be
     in the normative block.
   - Citations used only for background or comparison SHOULD be informative.

3. Check for broken anchors: `{#X}` defined but never referenced (informational
   only — not a blocking issue, but worth noting).

Output each finding as:
```
XREF-N: <location> — <issue>
```

---

## TASK 4: XDR Review (skip if XDR not present)

Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/xdr.md` and apply all checks.

Additionally:

1. **Extractability**: simulate extracting XDR by finding all lines matching
   `^ */// ` (or the extraction sentinel used in this draft).  Verify:
   - No line is missing its sentinel where it should have one
   - The extracted block would compile as standalone XDR (no forward references
     to undefined types, no duplicate definitions)

2. **Completeness**: every operation listed in the opnum enum has corresponding
   args and res structs defined.  Every args/res struct used in `nfs_argop4` /
   `nfs_resop4` (or equivalent dispatch union) is defined.

3. **Consistency with prose**: for each operation with an ARGUMENTS and RESULTS
   section, verify the XDR field names match the field descriptions in the prose.

Output each finding as:
```
XDR-N: <type or operation name> — <issue>
```

---

## TASK 5: IANA Considerations

Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/iana.md` and apply all checks.

Output each finding as:
```
IANA-N: <registry or constant> — <issue>
```

---

## TASK 6: Security Considerations

Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/security.md` and apply all checks.

Output each finding as:
```
SEC-N: <topic> — <issue>
```

---

## TASK 7: Editorial Issues

Scan the entire draft for:

1. **Remaining editorial notes**: `<cref`, `<!-- TODO`, `_TBD_`, placeholder
   section headings with no body text.

2. **Typos and grammar**: obvious spelling errors, repeated words ("the the"),
   broken sentence fragments.

3. **Inconsistent terminology**: the same concept referred to by two different
   names (e.g., "data server" vs "storage device" used interchangeably without
   definition).

4. **Stale references**: text that refers to a section, figure, or operation
   that no longer exists in the draft.

Output each finding as:
```
EDIT-N: <location> — <issue>
```

---

## TASK 8: Submission Nits (idnits)

Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/idnits.md` and apply all checks.

The IETF datatracker runs `idnits` on every submitted draft.  These
checks catch source-level patterns that produce idnits errors or
warnings in the rendered output.

Focus on:
1. Non-ASCII characters in the source (curly quotes, em dashes, etc.)
2. Lines inside code blocks, XDR fragments, ASCII art, and tables that
   exceed 69 characters (xml2rfc adds a 3-character indent)
3. Missing front matter fields (`ipr:`, `docname:`, `category:`)
4. Abstract length

Output each finding as:
```
IDNITS-N: <location> — <issue>
```

---

## TASK 9: False Positive Check

Load `{{IETF_REVIEW_PROMPTS_DIR}}/false-positive-guide.md`.

Apply each check to eliminate findings that are not real issues.
Remove eliminated findings from the report.

---

## TASK 10: Report

Load `{{IETF_REVIEW_PROMPTS_DIR}}/inline-template.md`.

Before writing: every finding must be framed as a technical question or
reasoned observation, not an assertion of error.  The goal is to help
the document reach rough consensus (RFC 2418), not to block it.  Apply
the conduct standards of RFC 7154 and netiquette of RFC 1855.

- If NO findings remain: summarize what was checked and confirm the draft
  is clean.  No output file needed.

- If findings remain: create `review-comments.txt` in the current directory
  following the format in `inline-template.md`.

Output:
```
TOTAL FINDINGS: <number>
  STRUCTURE:  <n>
  RFC2119:    <n>
  XREF:       <n>
  XDR:        <n>
  IANA:       <n>
  SEC:        <n>
  EDITORIAL:  <n>
  IDNITS:     <n>
```
