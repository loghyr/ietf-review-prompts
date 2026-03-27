Read REVIEW_DIR/review-core.md for context on what the checks mean.

Perform a rapid pre-submission verification of the draft.  This is a
checklist pass, not a full review.  Answer each item yes/no/na.

Checklist:

STRUCTURE
[ ] Abstract is present and non-empty
[ ] Requirements Language section is present with BCP 14 boilerplate
[ ] Security Considerations is present and non-empty
[ ] IANA Considerations is present (or explicitly "this doc has none")
[ ] Normative References section is present
[ ] No section contains only a placeholder or <cref> todo

NORMATIVE LANGUAGE
[ ] RFC 2119 boilerplate cites both RFC 2119 and RFC 8174
[ ] No lowercase normative words (must/should/may) in normative prose
[ ] No use of "will" as a normative term

CROSS-REFERENCES
[ ] All {{sec-X}} references have matching {#sec-X} anchors
[ ] All {{RFCXXXX}} citations are in normative or informative references block
[ ] Normative citations in normative prose are in the normative block

XDR (skip if no XDR present)
[ ] Extraction sentinel (/// ) used consistently
[ ] Every OP_* constant has args and res structs defined
[ ] All types used in dispatch unions are defined
[ ] Field prefixes are consistent within each struct

IANA
[ ] Every new constant/type in the draft body has a registration entry
[ ] All IANA tables use correct column format for the target registry
[ ] New registries have stated allocation policies

SECURITY
[ ] Security section addresses authentication model
[ ] New error codes discussed for information leakage if applicable
[ ] CRC/checksum not described as providing security (integrity ≠ security)

Output a summary line: READY / NOT READY, with a count of failed items.
