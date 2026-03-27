# False Positive Guide for IETF Draft Review

Apply these checks before reporting any finding.  Eliminate findings that
match one of these patterns.

## RFC 2119 False Positives

FP-1: Lowercase normative words in section titles or figure captions.
  "must" in a section title is not a normative requirement.  Only flag
  lowercase normative words in normative prose paragraphs.

FP-2: Normative words inside quoted text or examples.
  Text inside backticks, code blocks, or explicitly quoted RFC text is
  not subject to RFC 2119 rules.  Do not flag normative words inside
  ~~~ blocks or `inline code`.

FP-3: "may" meaning "it is possible that" rather than "is permitted to".
  Read the sentence in context.  "This error may occur when..." is
  descriptive, not permissive.

FP-4: Requirements Language section itself.
  The boilerplate paragraph defining the key words is not subject to
  its own rules.

## Cross-Reference False Positives

FP-5: RFC citations in the abstract.
  The abstract is not normative prose.  RFC citations in the abstract
  do not need to appear in the normative references block.

FP-6: Self-referential anchors in XDR figure captions.
  `{: #fig-FOO title="XDR for FOO"}` is a figure caption anchor, not
  a broken reference even if nothing in the prose cites it.

FP-7: Forward references to sections that exist.
  A reference to `{{sec-X}}` is valid as long as `{#sec-X}` appears
  anywhere in the document, including after the reference site.

## XDR False Positives

FP-8: Types defined in a base RFC and reused.
  Types like `offset4`, `count4`, `stateid4`, `nfsstat4` come from
  RFC 7863 (NFSv4.2 XDR) and do not need to be defined in the draft.
  Do not flag their use as undefined types.

FP-9: XDR comment lines (`/* ... */`) with no sentinel.
  Comment-only lines in XDR blocks do not need the extraction sentinel.
  Only lines that produce compilable XDR output need it.

FP-10: Intentional stubs marked NFS4ERR_NOTSUPP.
  Operations that explicitly return NFS4ERR_NOTSUPP in prose as
  "reserved for future use" need only minimal args/res structure.
  Do not flag missing fields in acknowledged stub operations.

## IANA False Positives

FP-11: "RFC TBD" or "RFCTBD" in IANA tables.
  This is the correct placeholder for the RFC number before publication.
  Do not flag it as missing or incorrect.

FP-12: Informative IANA discussion in Security Considerations.
  Cross-referencing the IANA section from Security Considerations is
  normal.  Do not flag it as a duplicate registration.

## Security False Positives

FP-13: Security Considerations that reference a parent document.
  "This document has the same security considerations as {{RFC-XXXX}}"
  is acceptable when the new protocol elements introduce no new threats
  beyond those already analyzed in the referenced document.  Only flag
  this if the draft does introduce new attack surfaces not covered
  by the referenced document.

## Editorial False Positives

FP-14: `<cref>` notes marked with a specific author and a clear action item.
  These are tracked editorial notes, not forgotten placeholders.
  Note them as "open editorial notes" rather than blocking issues.

FP-15: Terminology variation within a definitions section.
  A definitions section that defines multiple related terms using
  those terms is not inconsistent — it is defining them.

## idnits False Positives

FP-16: Non-ASCII characters in author names or reference titles.
  Author names with diacritics (e.g., "M\u00FCller") are correct and
  acceptable.  idnits flags them but they should not be changed.
  Only flag non-ASCII in prose text, code blocks, or comments.

FP-17: Long lines in externally generated content.
  If a table or figure is machine-generated and the source is not
  directly editable (e.g., an included YANG module), note the issue
  but do not flag it as blocking.

FP-18: TEXT_DOC_REF warnings for array indices in ASCII art.
  The datatracker validator flags `[0]`, `[1]`, etc. inside artwork
  blocks as text-document references (e.g., "[1] looks like a
  citation").  In NFS and other protocol specs, these are array
  indices in protocol diagrams (e.g., `cwr_owners[0]`,
  `ffl_mirrors[1]`).  These are false positives and cannot be
  fixed without removing standard array notation from diagrams.

FP-19: INVALID_REFERENCES_NAME for nested references wrapper.
  kramdown-rfc generates a `<references><name>References</name>`
  outer wrapper around the Normative and Informative subsections.
  This is correct per RFC 7991 (xml2rfc v3 vocabulary), but the
  datatracker validator flags it because it expects every
  `<references>` name to be "Normative" or "Informative".  This
  is a tool-chain issue, not a draft error.

FP-20: LINE_PI warnings for processing instruction tags.
  kramdown-rfc inserts `<?line NNN?>` processing instructions for
  source line tracking.  The validator flags these but they are
  tool-generated and not controllable from the markdown source.

FP-21: MISSING_DOC_DATE when using i-d-template placeholder.
  Drafts using Martin Thomson's i-d-template often have
  `date: {DATE}` in the YAML front matter.  The Makefile replaces
  this placeholder at build time.  The validator flags it during
  local builds but submission tooling handles it correctly.
