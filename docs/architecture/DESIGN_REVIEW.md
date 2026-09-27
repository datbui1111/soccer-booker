# Soccer Booker v1.0 — Design Review Checklist

## Scope
Review record for the Week 3 design artifacts already present in the repository.

## Artifacts reviewed
- docs/SRS_v1.0.md
- docs/RTM_v3.0.md
- docs/architecture/C4/
- docs/architecture/DFD/
- docs/architecture/UML/
- database/schema.sql
- api/openapi.yaml
- .github/workflows/ci.yml

## Review checklist
- [ ] SRS contains FR, NFR, and UC-01..UC-09.
- [ ] RTM traces 55/55 FR and 19/19 NFR.
- [ ] C4, DFD, and UML are consistent with the requirements.
- [ ] Database schema is PostgreSQL 15+ and validated by CI.
- [ ] OpenAPI 3.0.3 is documented and FR-traceable.
- [ ] CI validates the documentation, OpenAPI, PlantUML markers, and schema.

## Review outcome
Reviewer should verify the checklist on the Pull Request and submit the appropriate GitHub review before merge.
