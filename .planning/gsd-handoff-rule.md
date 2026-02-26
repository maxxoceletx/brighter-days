# Development Handoff Rule

When a phase involves actual software development (writing application code, building dashboards, creating APIs, etc.), GSD should:

1. Complete all research, requirements gathering, and spec writing for that phase as normal
2. Produce a detailed implementation spec in `.planning/phases/` with:
   - Exact features and acceptance criteria
   - Tech stack decisions
   - Architecture notes
   - File structure expectations
3. STOP before execution and output:
   "⚠️ SOFTWARE PHASE READY FOR HANDOFF — This phase requires code implementation. The spec is at `.planning/phases/[XX]/spec.md`. Open a new Claude Code session with Superpowers to execute this spec using TDD."
4. Do NOT spawn coding subagents for these phases

## Ownership

**GSD owns:** research, compliance, credentialing, operations, document organization, business planning, and spec writing.

**Superpowers owns:** code implementation, testing, debugging, and code review.
