# Contributing Guidelines

## Community Standards

This project generates output intended for IETF working group mailing lists.
All contributions — to the prompts themselves and to any reviews they produce
— must follow the standards of the IETF community:

- **RFC 7154** (IETF Guidelines for Conduct): Treat colleagues with respect
  and courtesy.  Dispute ideas using reasoned argument, not personal attack
  or intimidation.  Support positions with data and facts.

- **RFC 1855** (Netiquette Guidelines): Keep messages brief and focused.
  Quote only what provides necessary context — never reproduce an entire
  message.  Attribute quotes correctly.  Disagreements that have become
  personal should move to private email; the list is for technical discussion.

- **RFC 2418** (WG Guidelines and Procedures): The goal of WG discussion is
  rough consensus, not winning an argument.  Volume of messages does not
  indicate consensus.  Familiarize yourself with the relevant drafts and
  RFCs before participating.

## Improving the Prompts

Prompt improvements are welcome via pull request.  When proposing changes:

- Explain the class of issue the change catches or prevents.
- If the change affects the output format, show a before/after example.
- False positive fixes are especially valuable — include the case that
  was incorrectly flagged.

## Reporting Issues

Open a GitHub issue to report:
- A review finding that is consistently wrong (false positive)
- A class of real problem the prompts consistently miss (false negative)
- Output that violates the conduct standards above

## Scope

These prompts are intentionally generic across IETF working groups.
Protocol-specific pattern files (analogous to `patterns/xdr.md` for NFSv4)
for other protocol families are welcome additions.
