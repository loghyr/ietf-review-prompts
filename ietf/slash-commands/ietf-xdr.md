Read REVIEW_DIR/patterns/xdr.md

Apply only the XDR checks from that pattern file to the specified draft
(or the draft-*.md file in the current directory).

Focus on:
1. Extraction sentinel consistency
2. Type naming and field prefix conventions
3. Operation completeness (args/res for every opnum)
4. Dispatch union completeness
5. Consistency between XDR field names and prose descriptions

Report findings in the format:
  XDR-N: <type or operation name> -- <issue>

If no issues are found, confirm that the XDR appears complete and
consistently formatted.
