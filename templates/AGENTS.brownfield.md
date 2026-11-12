
## 10. Existing-project guardrails (CRITICAL)

This project existed before the framework was installed. These rules override anything above.

- **Onboard first.** Until the architecture map (`docs/00-onboarding/architecture-map-v*.md`) is `Approved`, run only the onboarding agent.
- **Do not rewrite.** Do not refactor or rewrite existing files unless the human explicitly asks.
- **Surgical changes.** Make the smallest change that implements the requirement.
- **Test before change.** Before modifying an existing file, make sure tests cover its current behavior. If they don't, write characterization tests first, in their own commit.
- **Isolation.** Put new features in new files. Modify existing files only to register or wire up the new feature.
- **Existing features** are documented as REQs with status `Done` in the as-built PRD, so later changes to them are traceable.
