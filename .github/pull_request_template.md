## What changed and why?

<!-- Describe the change and the motivation. Link to relevant issues or discussions. -->

---

## Checklist

### Code quality
- [ ] CI passes (formatting, vet, build, tests)
- [ ] New domain logic has unit tests
- [ ] New infrastructure interactions have integration tests
- [ ] No unrelated files were modified

### Architecture
- [ ] Clean Architecture layer boundaries are preserved (no DB or HTTP imports in domain/application)
- [ ] Platform and game-specific logic remain separated
- [ ] The smallest correct change was made — no scope creep or unrelated refactoring

### Contracts and API
- [ ] If the server API changed, `packages/contracts/` was updated
- [ ] If contracts changed, all consuming clients (web, admin, mobile) were updated or a migration plan was documented

### Database
- [ ] If the schema changed, a new migration file was added to `server/migrations/`
- [ ] No existing migration files were modified

### Documentation
- [ ] Architecture docs updated if the design changed (`docs/architecture/`)
- [ ] An ADR was added or updated if a technology or architecture decision changed (`docs/decisions/`)
- [ ] Workflow docs updated if a process changed (`docs/workflows/`)

### For AI-generated changes
- [ ] The change was reviewed for correctness, not just for CI passage
- [ ] No established architecture was silently redesigned
- [ ] No speculative features were introduced beyond the stated task scope
