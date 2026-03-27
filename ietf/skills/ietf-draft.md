---
name: ietf-draft
description: Load when working in a directory containing IETF Internet-Drafts (draft-*.md files with IETF front matter). Provides IETF draft review, verification, and XDR analysis capabilities.
invocation_policy: automatic
---

## Detection

This skill is active when the working directory contains one or more files
matching `draft-*.md` that include IETF front matter fields (`docname:`,
`category:`, `ipr:`).

## Configuration

The review prompts directory is configured during installation:
- **IETF_REVIEW_PROMPTS_DIR**: {{IETF_REVIEW_PROMPTS_DIR}}

## Capabilities

### Full Draft Review
When asked to review an IETF draft:
1. Load `{{IETF_REVIEW_PROMPTS_DIR}}/review-core.md`
2. Follow the complete review protocol defined there
3. Load pattern files as directed by review-core.md

### Pre-Submission Verification
When asked to verify a draft is ready for submission or WG last call:
1. Load `{{IETF_REVIEW_PROMPTS_DIR}}/slash-commands/ietf-verify.md`
2. Follow the verification checklist

### XDR Review
When asked to review only the XDR portions of a draft:
1. Load `{{IETF_REVIEW_PROMPTS_DIR}}/patterns/xdr.md`
2. Apply XDR-specific checks only

## Output

- Draft reviews produce `review-comments.txt` when issues are found,
  formatted for posting to an IETF working group mailing list.
- Verification produces a pass/fail checklist to stdout.
- All output is plain text, 72-character line wrap, no markdown.
