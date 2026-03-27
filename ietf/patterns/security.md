# Security Considerations Patterns

## Minimum Coverage

The Security Considerations section MUST NOT be empty or consist solely
of "This document has no security considerations."

For any draft that defines new protocol operations, wire formats, or
registry values, the section MUST address:

1. **Authentication and authorization**: how is the caller's identity
   verified? What prevents unauthorized use of the new operations?

2. **Data integrity**: can the new data on the wire be tampered with
   in transit? Is there a mechanism to detect tampering?

3. **Replay attacks**: can a recorded message be replayed to cause
   unintended effects?

4. **Denial of service**: can the new operations be used to exhaust
   server resources (memory, connections, computation)?

5. **Privacy**: does the new protocol expose information that should
   be confidential (file contents, user identities, metadata)?

## Acceptable Short Forms

These forms are acceptable IF the referenced document's security
analysis actually covers the new protocol elements:

  "This document has the same security considerations as [RFC-XXXX]."

  "The security considerations of [RFC-XXXX] apply to this document."

Flag this form as potentially insufficient if the draft introduces:
- New error codes that reveal server-side state to unauthenticated callers
- New operations with different authentication requirements than the base
- New data formats that could carry malformed input to implementations
- New identifiers or tokens that have replay or enumeration risks

## New Error Codes

New error codes that carry information about server state MUST be
discussed.  Specifically: can an unauthenticated or unauthorized caller
use the error code to probe server state or enumerate valid values?

Example: an error code NFS4ERR_FILE_EXISTS returned to an unauthorized
caller reveals that the file exists, which may be confidential.

## Cryptographic Considerations

If the draft introduces checksums, CRCs, or hashes:
- CRC32 provides error detection, NOT integrity protection against
  adversarial modification.  The security section MUST NOT claim CRC32
  provides security.
- If integrity protection is needed against adversarial modification,
  a cryptographic MAC or authenticated encryption is required.

## Synthetic Credentials / Fencing

If the draft uses synthetic uid/gid or token-based access control
for data servers (common in pNFS layouts):
- The mechanism for credential rotation (fencing) MUST be described.
- The window of vulnerability between credential compromise and
  successful fencing MUST be acknowledged.
- The trust model (MDS trusted by DS, client not trusted by DS) MUST
  be stated.

## Common Security Mistakes

SEC-PAT-1: Security section references a base RFC but the draft
  introduces new attack surfaces not covered by that RFC.

SEC-PAT-2: CRC32 described as providing data integrity (it does not
  protect against intentional modification).

SEC-PAT-3: New operation described as "safe" without stating the
  authentication model that enforces this.

SEC-PAT-4: New error codes not discussed in terms of information leakage.

SEC-PAT-5: Credential/fencing model described elsewhere in the draft
  but not cross-referenced from Security Considerations.
