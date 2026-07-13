# Repository Architecture v3.0

```text
Campaign facts and source PDFs
            ↓
Verified rules and extraction notes
            ↓
Pillars (why)
            ↓
Engines (how)
            ↓
Systems (what/source category)
            ↓
Structured databases
            ↓
Generated indexes and exports
```

## Update protocol

1. Add or revise the canonical campaign rule first.
2. Update the matching JSON database.
3. Add or revise the relevant system entry.
4. Update every affected engine.
5. Add pillar-impact metadata.
6. Update the campaign timeline where provenance matters.
7. Run validators.
8. Record the change in `CHANGELOG.md`.
