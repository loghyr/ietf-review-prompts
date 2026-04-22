# Downref Detection and Resolution

## What Is a Downref?

A **downref** occurs when a Standards Track (or BCP) document cites
an Informational or Experimental RFC in its Normative References block.
RFC 3967 requires that such citations be explicitly approved, either by
inclusion in the IESG's Downref Registry or by explicit IESG approval
during publication.

The specific trigger: any RFC in the `normative:` block (kramdown-rfc)
or `<references title="Normative References">` section (XML) whose
`status` is Informational or Experimental.

## Detection

For each normative reference, check its RFC status:
```
https://datatracker.ietf.org/doc/rfcNNNN/
```
If `status: Informational` or `status: Experimental` and the
citing document is Standards Track, this is a potential downref.

Also check the Downref Registry at:
```
https://www.rfc-editor.org/refs/ref-downref.txt
```
If the Informational RFC is already in the registry (e.g.,
"RFC 3552 is a downref when cited normatively from Standards Track"),
no additional IANA action is needed -- the registry entry covers it.

## Two Resolution Paths

### Path 1: Move to Informative References

If the reference is not actually load-bearing (the document's
compliance requirements do not depend on the reader implementing
or reading the cited RFC), move it to the Informative block.

Test: remove the normative citation mentally.  Can every MUST,
SHOULD, and MUST NOT in the draft still be satisfied without
reading the cited RFC?  If yes, the reference is informative.

After moving, apply FP-23: a MUST that says "if you implement X
({{RFC-YYYY}}), then you MUST do Y" is a conditional MUST whose
reference is informative.  The MUST governs scope of compliance,
not an unconditional implementation requirement.

### Path 2: Downref Registry Entry

If the reference is genuinely load-bearing (the reader must
implement or consult the cited RFC to comply with any MUST in
the draft), it cannot be moved to informative.  Instead:

1. Add an explicit note in the Normative References section:
   "Note: RFC YYYY is an Informational document.  Its inclusion
   here was approved per RFC 3967."
2. Include a Downref Registry request in the IANA Considerations
   section or shepherd writeup.
3. The IESG will process the registry entry during publication.

## The Conditional MUST Nuance

The most common false positive in downref detection:

```
   If a client supports feature X [RFC7204], the client MUST
   configure Y before using X.
```

Here RFC 7204 defines feature X.  Moving RFC 7204 to Informative
is correct IF implementing feature X is optional.  The MUST
imposes a sequencing constraint on clients that choose to implement X,
not a blanket requirement to implement X.

Contrast with a load-bearing normative dependency:

```
   The client MUST implement the algorithm defined in Section 3
   of [RFC7204].
```

This cannot be moved to Informative because compliance with the MUST
requires reading RFC 7204 Section 3.

## Shepherd Writeup Note

The shepherd writeup (RFC 4858) asks: "Does this document contain
a downref?"  If the document has one resolved via Path 2, the
shepherd must:

1. Confirm the downref is intentional
2. Identify whether the referenced RFC is already in the Downref
   Registry or whether a new entry is needed
3. Document this explicitly in the writeup so the IESG knows to
   expect it during IETF Last Call (RFC 3967 requires Last Call
   notice for new downrefs)

## Common Informational RFCs Cited in NFSv4 Extensions

| RFC | Title | Status | Notes |
|-----|-------|--------|-------|
| RFC 7204 | Requirements for Labeled NFS | Informational | Use conditional MUST; move to informative |
| RFC 3552 | Security Considerations Guidelines | Informational | In Downref Registry; no new action needed |
| RFC 4949 | Internet Security Glossary | Informational | Move to informative; only for terminology |
