# IANA Considerations Patterns

## Completeness Check

For every new constant, type, operation number, error code, or registry
introduced anywhere in the draft body, verify that the IANA Considerations
section contains a corresponding registration request.

Common places to look for new values that need IANA registration:
- Enum definitions in XDR (new enum values added to an existing registry)
- New error codes (e.g., NFS4ERR_* values)
- New operation numbers
- New layout type numbers
- New flag bit assignments
- New attribute numbers
- New encoding type registries introduced by the draft itself

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
  Every new enum value or constant that extends an existing IANA registry
  must have an entry in IANA Considerations.

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
