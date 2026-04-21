# IANA Considerations Patterns

## NFSv4 Operation Numbers

NFSv4 operation numbers do NOT require an explicit IANA registration
entry.  An operation is "approved" by virtue of appearing in a
standards-track document.  The operation number assigned in the draft
body (e.g., "Operation 81: EXCHANGE_RANGE") is sufficient; no
registration table in IANA Considerations is needed for the op number
itself.  Do NOT flag a missing IANA entry for an operation number as an
error.

This applies to: new OP_* constants, operation section titles of the
form "Operation N: NAME", and corresponding OP_NAME entries in the
opnum enum.

Other values (error codes, layout types, flag bits, attribute numbers,
new registries) still require explicit IANA registration entries -- see
below.

## When IANA Action Is Actually Required

**Default assumption: no IANA action is required.**  A new constant,
enum value, flag bit, error code, or attribute number in an
Internet-Draft only needs an IANA Considerations entry when one of
the following is true:

1. **The value extends a registry that already exists in a
   published RFC.**  The reviewer must cite the specific published
   RFC that established the registry.  "Probably there's a
   registry for X" is not sufficient -- find it or assume there
   isn't one.

2. **The draft itself creates a new registry** and populates it
   with initial values.  In that case the New Registry Creation
   rules below apply.

If neither is true, do not flag a missing IANA entry as a finding.
Standards-track NFSv4 documents routinely define new OP_* numbers,
NFS4ERR_* codes, EXCHGID4_FLAG_* bits, FATTR4_* attribute numbers,
flag bits on new bitmaps defined by the same draft, and per-draft
enum types without IANA entries, because no IANA registry governs
them -- the standards-track document itself is the authoritative
record.  Flagging these as missing IANA registrations creates noise
and pushes back on authors to add registrations that IANA does not
want and will not process.

When in doubt, search for the registry on
<https://www.iana.org/protocols> before raising a finding.  If the
search comes up empty, the default assumption stands and there is
no finding to raise.

### Cases that DO require an IANA entry

These are the cases where an IANA registry exists in a published
RFC and is extensible by later documents:

- **pNFS Layout Types Registry** (RFC 8881 S22.4): new
  `LAYOUT4_*` type numbers extend this registry and require an
  entry.
- **NFSv4 Recallable Object Types Registry** (RFC 8881 S22.3):
  new `RCA4_TYPE_MASK_*` values extend this registry.
- **Other registries explicitly created by RFC 8881 or a peer
  NFSv4 RFC**: check RFC 8881 S22 (IANA Considerations) for the
  full list -- it is the canonical starting point for NFSv4
  drafts.
- **Registries created by non-NFSv4 base documents** the draft
  depends on (e.g., DNS, HTTP, TLS): check the base document's
  IANA section.

For all other newly-introduced wire values (error codes,
attribute numbers, flag bits, op numbers, enum values of
draft-defined types), the standards-track document is the
record.  No IANA action is needed or appropriate.

### Examples (from real drafts)

| Introduced by a draft | IANA action? | Why |
|-----------------------|--------------|-----|
| New `OP_FOO = 87` | No | Op numbers are governed by the publishing document, not a registry |
| New `NFS4ERR_FOO = 10097` | No | nfsstat4 codes are governed by the publishing document |
| New `FATTR4_FOO = 89` | No | Per-draft attribute numbers are governed by the publishing document |
| New `EXCHGID4_FLAG_USE_FOO = 0x00100000` | No | EXCHGID flags are governed by the publishing document |
| New `LAYOUT4_FOO = 5` | **Yes** | pNFS Layout Types Registry exists in RFC 8881 S22.4 |
| New `RCA4_TYPE_MASK_FOO = 20` | **Yes** | NFSv4 Recallable Object Types Registry exists in RFC 8881 S22.3 |
| New flag bit in a bitmap defined by THIS draft | No | The draft owns the bit space it introduces |
| New flag bit in a bitmap defined by a prior RFC that has an IANA registry | **Yes** | Extends a published registry |
| New registry created by THIS draft with initial values | **Yes** | New Registry Creation rules apply |

## Registry Format

Each registration request MUST include:
1. The registry name (exact name as it appears in the IANA registry)
2. The value being assigned (or "TBD" / "IANA" for IANA-assigned values)
3. The RFC reference ("RFC TBD" or "[This RFC]" is correct for drafts)
4. Any additional required columns (allocation policy, description, etc.)

Check that table column headers match the existing registry's column
headers exactly.  A mismatch causes processing errors at IANA.

## New Registry Creation

If the draft creates a new registry:
1. The registry name MUST be stated explicitly.
2. The allocation policy MUST be specified using IANA-standard terms:
   - Standards Action
   - IETF Review
   - Expert Review
   - First Come First Served
   - Private Use
   - Experimental Use
3. Initial entries MUST be listed in a table.
4. The designated expert (if Expert Review) SHOULD be described or the
   criteria for Expert Review guidance stated.
5. The registration procedure for each range (if range-partitioned) MUST
   be stated.

## Range Partitioning

If a registry is range-partitioned (e.g., 0x0000-0x00FF for Standards
Track, 0x0100-0x0FFF for Experimental), verify:
- The ranges are contiguous and cover the full value space.
- The allocation policy per range is specified.
- Values assigned in the draft body fall within the Standards Track range.
- No range overlaps with an existing allocation.

## Common IANA Mistakes

IANA-PAT-1: New XDR constant defined but not registered.
  Applies ONLY when the new enum value or constant extends a
  registry that already exists in a published RFC (the reviewer
  must cite the RFC and registry name), OR when the draft itself
  creates a new registry.  If neither is true, the publishing
  document is itself the authoritative record and no IANA entry
  is required -- do not raise a finding.  See "When IANA Action
  Is Actually Required" at the top of this file.
  Exception: NFSv4 operation numbers (OP_NAME constants and operation
  section titles) are approved by the standards-track document itself
  and do not require a separate registration entry.

IANA-PAT-2: Registry table column count does not match existing registry.
  Check the actual IANA registry page for the column format.

IANA-PAT-3: "RFC TBD" missing — plain number used instead.
  Pre-RFC assignments use "RFC TBD" or "RFCTBDNN".  Using a real RFC
  number that hasn't been assigned yet is incorrect.

IANA-PAT-4: New registry created without specifying allocation policy.
  Every new registry must have a stated allocation procedure.

IANA-PAT-5: Value assigned in the draft is outside the Standards Track
  range for a range-partitioned registry.

IANA-PAT-6: Existing registry extended but the extension uses a different
  column format than the original entries.
