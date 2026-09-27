# RTM v3.0 — Soccer Booker

## 1. Coverage

**55/55 FR** are traced to a Use Case, GitHub Product Backlog issue, C4 C2 container, OpenAPI operation and DB/CSDL table. **19/19 NFR** are traced to verification artifacts.

Use Cases: UC-01..UC-09 in docs/SRS_v1.0.md. C4: C2-Web, C2-API, C2-DB; Browser Geolocation is external for FR-PITCH-002 and External Livestream is external for FR-LIVE-001/002.

## 2. Functional Requirements RTM

| FR | Priority | UC | Backlog | C4 | OpenAPI | DB/CSDL |
|---|---|---|---:|---|---|---|
| FR-AUTH-001 | Must | UC-01 | #10 | C2-Web, C2-API, C2-DB | POST /auth/register | users |
| FR-AUTH-002 | Must | UC-01 | #11 | C2-Web, C2-API, C2-DB | POST /auth/login | users |
| FR-AUTH-003 | Must | UC-01 | #12 | C2-Web, C2-API, C2-DB | POST /auth/logout | users |
| FR-AUTH-004 | Must | UC-01 | #13 | C2-Web, C2-API, C2-DB | GET/PATCH /me | users |
| FR-PITCH-001 | Must | UC-02 | #14 | C2-Web, C2-API, C2-DB | GET /pitches | pitches |
| FR-PITCH-002 | Must | UC-02 | #15 | C2-Web, C2-API, C2-DB, Browser Geolocation | GET /pitches | pitches |
| FR-PITCH-003 | Must | UC-02 | #16 | C2-Web, C2-API, C2-DB | GET /pitches | pitches |
| FR-PITCH-004 | Must | UC-02 | #17 | C2-Web, C2-API, C2-DB | GET /pitches | pitches |
| FR-PITCH-005 | Must | UC-02 | #18 | C2-Web, C2-API, C2-DB | GET /pitches/{pitchId} | pitches |
| FR-PITCH-006 | Must | UC-02 | #19 | C2-Web, C2-API, C2-DB | GET /pitches/{pitchId}/schedules | pitch_schedules |
| FR-PITCH-007 | Must | UC-02 | #20 | C2-Web, C2-API, C2-DB | POST /pitches/{pitchId}/schedules | pitch_schedules |
| FR-BOOK-001 | Must | UC-03 | #21 | C2-Web, C2-API, C2-DB | POST /bookings | bookings,pitch_schedules |
| FR-BOOK-002 | Must | UC-03 | #22 | C2-Web, C2-API, C2-DB | POST /bookings | bookings,pitch_schedules |
| FR-BOOK-003 | Must | UC-03 | #23 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId} | bookings |
| FR-BOOK-004 | Must | UC-03 | #24 | C2-Web, C2-API, C2-DB | GET /owner/bookings; POST /bookings/{bookingId} | bookings |
| FR-BOOK-005 | Must | UC-03 | #25 | C2-Web, C2-API, C2-DB | GET /bookings/{bookingId}/deposit | deposits,pitch_payment_settings |
| FR-BOOK-006 | Must | UC-03 | #26 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId}/deposit | deposits,bookings |
| FR-BOOK-007 | Must | UC-03 | #27 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId} | deposits,bookings |
| FR-BOOK-008 | Must | UC-03 | #28 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId}/expire | bookings,pitch_schedules |
| FR-BOOK-009 | Must | UC-03 | #29 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId} | bookings,deposits |
| FR-BOOK-010 | Must | UC-03 | #30 | C2-Web, C2-API, C2-DB | POST /bookings/{bookingId} | bookings,deposits |
| FR-BOOK-011 | Must | UC-03 | #31 | C2-Web, C2-API, C2-DB | GET /bookings; GET /bookings/{bookingId} | bookings |
| FR-BOOK-012 | Must | UC-03 | #32 | C2-Web, C2-API, C2-DB | GET /bookings | bookings |
| FR-BOOK-013 | Should | UC-03 | #33 | C2-Web, C2-API, C2-DB | GET /owner/bookings | bookings,users |
| FR-FEEDBACK-001 | Must | UC-04 | #34 | C2-Web, C2-API, C2-DB | POST /feedback | feedback,bookings |
| FR-FEEDBACK-002 | Must | UC-04 | #35 | C2-Web, C2-API, C2-DB | POST /feedback | feedback |
| FR-FEEDBACK-003 | Must | UC-04 | #36 | C2-Web, C2-API, C2-DB | POST /feedback | feedback |
| FR-FEEDBACK-004 | Must | UC-04 | #37 | C2-Web, C2-API, C2-DB | GET /pitches/{pitchId}/feedback | feedback |
| FR-FEEDBACK-005 | Must | UC-04 | #38 | C2-Web, C2-API, C2-DB | GET /pitches/{pitchId}/feedback | feedback |
| FR-TOUR-001 | Must | UC-05 | #39 | C2-Web, C2-API, C2-DB | POST /tournaments | tournaments |
| FR-TOUR-002 | Must | UC-05 | #40 | C2-Web, C2-API, C2-DB | PATCH /tournaments/{tournamentId} | tournaments |
| FR-TOUR-003 | Must | UC-05 | #41 | C2-Web, C2-API, C2-DB | DELETE /tournaments/{tournamentId} | tournaments |
| FR-TOUR-004 | Must | UC-05 | #42 | C2-Web, C2-API, C2-DB | GET /tournaments; GET /tournaments/{tournamentId} | tournaments |
| FR-TOUR-005 | Must | UC-05 | #43 | C2-Web, C2-API, C2-DB | POST /tournaments/{tournamentId}/registrations | tournament_registrations |
| FR-TOUR-006 | Must | UC-05 | #44 | C2-Web, C2-API, C2-DB | GET/POST tournament registrations/teams | teams,tournament_registrations |
| FR-MATCH-001 | Must | UC-06 | #45 | C2-Web, C2-API, C2-DB | POST /tournaments/{tournamentId}/matches | matches |
| FR-MATCH-002 | Must | UC-06 | #46 | C2-Web, C2-API, C2-DB | POST /tournaments/{tournamentId}/matches | matches |
| FR-MATCH-003 | Must | UC-06 | #47 | C2-Web, C2-API, C2-DB | PUT /matches/{matchId}/result | match_results,matches |
| FR-MATCH-004 | Must | UC-06 | #48 | C2-Web, C2-API, C2-DB | GET /tournaments/{tournamentId}/matches; GET /matches/{matchId} | matches |
| FR-TOUR-007 | Must | UC-07 | #49 | C2-Web, C2-API, C2-DB | GET /tournaments/{tournamentId}/standings | standings,match_results,matches |
| FR-TOUR-008 | Should | UC-07 | #65 | C2-Web, C2-API, C2-DB | GET /tournaments/{tournamentId}/player-stats | players |
| FR-TOUR-009 | Should | UC-07 | #66 | C2-Web, C2-API, C2-DB | GET /tournaments/{tournamentId}/player-stats | players,match_results |
| FR-COMMENT-001 | Should | UC-08 | #67 | C2-Web, C2-API, C2-DB | POST /comments | comments |
| FR-COMMENT-002 | Should | UC-08 | #68 | C2-Web, C2-API, C2-DB | GET /comments | comments |
| FR-LIVE-001 | Should | UC-08 | #69 | C2-Web, C2-API, C2-DB, External Livestream | PUT /matches/{matchId}/livestream | livestreams |
| FR-LIVE-002 | Should | UC-08 | #70 | C2-Web, C2-API, C2-DB, External Livestream | GET /matches/{matchId}/livestream | livestreams |
| FR-OWNER-001 | Must | UC-09 | #71 | C2-Web, C2-API, C2-DB | PATCH /me | users |
| FR-OWNER-002 | Must | UC-09 | #72 | C2-Web, C2-API, C2-DB | POST /pitches | pitches |
| FR-OWNER-003 | Must | UC-09 | #73 | C2-Web, C2-API, C2-DB | PATCH /pitches/{pitchId} | pitches |
| FR-OWNER-004 | Must | UC-09 | #74 | C2-Web, C2-API, C2-DB | DELETE /pitches/{pitchId} | pitches |
| FR-OWNER-005 | Must | UC-09 | #75 | C2-Web, C2-API, C2-DB | PUT /pitches/{pitchId}/pricing | pitch_payment_settings |
| FR-OWNER-006 | Must | UC-09 | #76 | C2-Web, C2-API, C2-DB | POST /pitches/{pitchId}/schedules | pitch_schedules |
| FR-OWNER-007 | Must | UC-09 | #77 | C2-Web, C2-API, C2-DB | POST /pitches/{pitchId}/schedules | pitch_schedules,matches |
| FR-OWNER-008 | Should | UC-09 | #78 | C2-Web, C2-API, C2-DB | PATCH /pitches/{pitchId} | pitches |
| FR-REVENUE-001 | Must | UC-09 | #79 | C2-Web, C2-API, C2-DB | GET /owner/revenue | revenues,bookings |

## 3. NFR RTM

| NFR | GitHub Issue | Verification / artifact |
|---|---:|---|
| NFR-01 | #80 | RTM + test report |
| NFR-02 | #81 | JMeter/k6 against API |
| NFR-03 | #82 | Lighthouse against Web Frontend |
| NFR-04 | #83 | Load test, C2-Web/C2-API/C2-DB |
| NFR-05 | #84 | Browser/device test |
| NFR-06 | #85 | OpenAPI contract test |
| NFR-07 | #86 | Booking usability test |
| NFR-08 | #87 | Booking state-transition test; BookingStatus/schema |
| NFR-09 | #88 | Monitoring/health check |
| NFR-10 | #89 | Fault/concurrency test |
| NFR-11 | #90 | Backup/restore test |
| NFR-12 | #91 | TLS/password security review |
| NFR-13 | #92 | Authentication test; bearerAuth |
| NFR-14 | #93 | Audit-log test; audit_logs |
| NFR-15 | #94 | Concurrent booking test; unique active booking index |
| NFR-16 | #95 | Architecture/dependency code review |
| NFR-17 | #96 | Coverage report + GitHub Actions |
| NFR-18 | #97 | Lint/build + code review |
| NFR-19 | #98 | Docker deployment + environment-variable review |

## 4. Data entity trace

| SRS entity | Schema |
|---|---|
| User / PitchOwner | users |
| Pitch | pitches |
| PitchSchedule | pitch_schedules |
| Booking | bookings |
| Deposit | deposits, pitch_payment_settings |
| Feedback | feedback |
| Tournament | tournaments |
| Player | players |
| Team | teams, tournament_registrations |
| Match | matches |
| MatchResult | match_results |
| Standing | standings |
| Comment | comments |
| Livestream | livestreams |
| Revenue | revenues |
| Audit | audit_logs |

## 5. Design notes

- PostgreSQL 15+ is the implementation choice for schema.sql; the SRS does not specify a DB vendor.
- Payment, transfer and refund remain external to Soccer Booker.
- FR-BOOK-008 is represented by a scheduled/internal expiry operation.
- Requirement IDs are unchanged from SRS/RTM v2.0.
