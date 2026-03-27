# IETF Mailing List Output Format

The output of a review is a plain-text message suitable for posting to an
IETF working group mailing list.  The standards that govern this kind of
communication are:

- RFC 7154 (IETF Guidelines for Conduct)
- RFC 1855 (Netiquette Guidelines)
- RFC 2418 (WG Guidelines and Procedures)

## Conduct

Critique ideas, not people (RFC 7154).  Support every finding with a
reasoned technical argument, not an assertion.  If the intent of a piece
of text is unclear, ask a question rather than assuming it is wrong.

The goal is to help the document reach rough consensus (RFC 2418), not to
block it.  Frame findings as "this could be clearer" or "this appears to
conflict with X" rather than "this is wrong."

## Format Rules (RFC 1855)

- Plain text.  Avoid heavy formatting; the list is read in many clients.
- Quote only enough of the prior message to establish context — never
  reproduce the entire draft or a large section of it.
- Attribute quotes correctly.
- Keep the message focused.  If a finding is tangential, consider whether
  it belongs in a separate message or a GitHub issue instead.
- Do not use ALL CAPS for emphasis outside of RFC 2119 key words.

## File Structure

The output file review-comments.txt follows this structure:

```
Subject: Re: <draft name and version>

<opening: what you reviewed and a brief overall impression>

<findings, one topic per paragraph, blank line between each>

<closing: invite discussion or note that findings are suggestions>
```

## Calibrating Language to Severity

Match the weight of the language to the severity of the issue:

Blocking / normative conflict:
  "Section 4.1 requires X, but Section 6.2 says Y — these appear to
  conflict.  Which takes precedence?"

Important but not blocking:
  "It would help to clarify what happens when... The current text
  could be read two ways."

Minor / editorial:
  "Nit: Section 2 alternates between 'data server' and 'storage device'.
  Picking one term and sticking to it would reduce ambiguity."

## Example

```
Subject: Re: draft-example-nfsv4-newfeature-03

I reviewed -03 and have a few comments.

Section 1.1 cites RFC 2119 for the BCP 14 key words but not RFC 8174,
which updated the boilerplate.  Current practice requires both
citations.

The XDR for NEW_OP4args includes a field np_guard of type new_guard4,
but that type does not appear to be defined anywhere in the document.
Is this intended to be chunk_guard4 from the base spec, or a new type?
If new, it will need a definition and an extraction sentinel.

Section 7 (Security Considerations) does not mention NFS4ERR_NEW_ERROR.
Since it is returned to the caller, it is worth a note on whether it
reveals any server state an unauthenticated client should not see.

Happy to discuss any of these on list or in a GitHub issue.
```

## What NOT to Include

- Do not list things that are correct.
- Do not reproduce large blocks of draft text.
- Do not extend disagreements that have become personal — take those
  off-list (RFC 1855).
- Do not add meta-commentary about the review process itself.
