# WG Process: Adoption, WGLC, and Shepherding

## WG Adoption

### What Adoption Means

WG adoption means the WG takes responsibility for the work.  It
does NOT mean the WG commits to publish it, that the design is
approved, or that the document is technically correct.  Adoption
is the start of the WG review process, not the end.

### Adoption Criteria (RFC 2418 S6.3)

A WG should adopt a document only if:
1. There is sufficient interest (typically measured by a call for
   adoption on the mailing list -- two weeks, no strong objections)
2. The document addresses a problem the WG's charter covers
3. The document is complete enough to review (not just an outline)
4. At least one WG participant is willing to actively shepherd it

### Adoption-with-Conditions

A WG may adopt a document with explicit conditions that must be met
before WGLC.  These conditions should be stated in the adoption call
result message and tracked in the WG issue tracker.  Common
conditions:
- "Adopt, but the security section must be rewritten before WGLC"
- "Adopt, but requires alignment with RFC-XXXX Section Y"
- "Adopt, but must drop the MDS-side server semantics"

When reviewing a document that has been adopted with conditions, check
whether those conditions have been satisfied before recommending WGLC.

### Adoption Assessment Checklist

```
ADOPTION-1: Is the problem in the WG charter scope?
ADOPTION-2: Is there a concrete motivation (not speculative)?
ADOPTION-3: Does the design interoperate with the base protocol?
ADOPTION-4: Are security considerations at least outlined?
ADOPTION-5: Is there at least one committed reviewer/shepherd?
ADOPTION-6: Are there any IPR disclosures that need disclosure per RFC 3979?
```

---

## WGLC (Working Group Last Call)

### What WGLC Means

WGLC (RFC 2418 S7.4) is a formal call for the WG to confirm the
document is ready for IETF Last Call.  It is NOT a rubber stamp.
WGLC objections must be resolved before the document can proceed.

### Editorial vs. Substantive Concerns

**Editorial concerns** (typos, formatting, minor wording): Author
fixes these; no WG consensus needed.

**Substantive concerns** (protocol correctness, scope, security
model, interoperability): These require either:
- Revised text that the objecting party explicitly acknowledges, OR
- A WG rough-consensus override (chair documents that the concern
  was heard but the WG disagrees)

### Silence Is Not Resolution

A WGLC DISCUSS-level objection (one that recommends against
publication) is NOT resolved by:
- The author posting a revised draft
- Time passing
- Other WG members expressing support

The objecting party must explicitly acknowledge that their concern
was addressed.  If they do not respond, the chair must:
1. Send a follow-up directly to the objector asking for acknowledgment
2. Set a two-week response deadline
3. If no response: document the situation and assess whether rough
   consensus exists to proceed despite the unanswered objection

### Chair Actions After WGLC

```
1. Collect all responses (minimum two weeks, longer for complex specs)
2. Sort responses: SUPPORT / EDITORIAL / SUBSTANTIVE OBJECTION
3. For each SUBSTANTIVE OBJECTION:
   a. Determine if author's revision addresses it
   b. Request explicit acknowledgment from objector (two-week deadline)
   c. If no acknowledgment: assess rough consensus override
4. Declare result: proceed / needs revision / reopen discussion
5. Document the consensus call result on the mailing list
```

### Rough Consensus vs. Unanimity

The IETF does not require unanimity (RFC 7282).  A sustained
objection from one participant does not block publication if:
- The concern has been genuinely considered
- The WG has debated it
- The majority view is that the revised text is adequate
- The chair documents this reasoning explicitly

However, a single DISCUSS from a recognized expert in the
relevant area (e.g., the original RFC author, an AD) carries
more weight than a DISCUSS from a peripheral participant.

### WGLC Review Checklist

When reviewing a draft at WGLC stage:

```
WGLC-1: Are all WGLC objections from the mailing list listed?
WGLC-2: For each SUBSTANTIVE objection: has the author addressed it?
WGLC-3: For each addressed objection: has the objector acknowledged?
WGLC-4: Are there any unanswered DISCUSS-level concerns?
WGLC-5: Does the document have a completed shepherd writeup (RFC 4858)?
WGLC-6: Are there any downrefs that need IESG attention?
WGLC-7: Are IANA registrations complete and correct?
WGLC-8: Have all normative references been published as RFCs?
         (Internet-Drafts cannot be normative references)
```

---

## Document Shepherding (RFC 4858)

### What the Shepherd Does

The document shepherd tracks a WG document from adoption to RFC
Editor queue.  The shepherd is NOT the WG chair (usually) and is
NOT the author.  The shepherd is a disinterested WG participant
who knows the document well enough to answer AD questions.

### RFC 4858 Ten-Question Assessment

The shepherd writeup must answer:

1. **Review quality**: Who reviewed the document, and were the
   reviews substantive?  A document with only one informal review
   is not ready.

2. **Consensus quality**: Is the consensus broad or narrow?
   "Two people agreed" is narrow; "vigorous list discussion with
   no sustained objections" is broad.  Document which.

3. **Controversy**: Were there any sustained objections?  If so,
   how were they resolved?  (Rough consensus override must be
   documented here.)

4. **Discarded objections**: Were any objections overridden?
   Explain why the WG reached rough consensus despite them.

5. **IPR**: Have all authors confirmed no undisclosed IPR?
   Check RFC 3979 disclosures on the datatracker.

6. **Formal review**: Has the document received Gen-ART,
   SecDir, or other formal review?  If not, note that.

7. **IANA**: Is the IANA Considerations section complete?
   Are there downrefs requiring Downref Registry entries?

8. **Downrefs**: List any downrefs explicitly with their
   resolution path (Path 1 or Path 2 per patterns/downref.md).

9. **AD concerns**: Are there any known AD or IESG concerns?
   List pre-IESG issues so the AD is not surprised.

10. **Implementation**: Is there at least one implementation?
    Two interoperating implementations are expected for
    Standards Track; document what exists.

### Normative Dependency Sequencing

If Document A cites Document B normatively, and both are in the
WG queue, A cannot advance to IESG before B is published as an RFC.
The shepherd must:

1. Identify all normative references that are Internet-Drafts
2. Confirm those drafts are also in the IETF queue (not abandoned)
3. Alert the AD to the sequencing dependency in the writeup
4. Monitor B's progress; if B stalls, A stalls too

Example: if uncacheable-directories cites uncacheable-files
normatively, uncacheable-directories cannot proceed to IESG review
until uncacheable-files is an RFC (or at minimum approved by the IESG).

### Common Shepherd Failure Modes

- **Accepting "no objections" as broad consensus**: silence on a
  mailing list is weak evidence.  Check whether key WG members
  (original protocol authors, implementers) actually reviewed it.

- **Not chasing the objector**: a DISCUSS-level objection that the
  author addressed but the objector never acknowledged is NOT
  resolved.  The shepherd must actively close the loop.

- **Missing the downref**: moving an RFC from normative to
  informative is a resolution, but the writeup must explain why
  the reference can be informative (the conditional-MUST test
  per patterns/downref.md).

- **Not documenting rough consensus overrides**: if the WG
  proceeded over a sustained objection, the writeup must say so
  explicitly.  Hiding it in "no objections were raised" is
  inaccurate and will cause an AD DISCUSS.
