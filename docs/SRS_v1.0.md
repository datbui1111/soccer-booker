# SRS v1.0 — Soccer Booker

**Platform:** Web Application · **Status:** Draft

## 1. Introduction
Soccer Booker supports football-pitch search, booking, pitch-owner management and amateur tournament information. The system has two primary roles: **User** and **Pitch Owner**.

### Scope
In scope: accounts, pitch search/filter/nearby search, pitch schedules, booking, external deposit workflow, cancellation, booking history/statistics, feedback/rating, pitch-owner management, revenue statistics, tournaments, teams, matches, results, standings, player/top-scorer statistics, comments in allowed areas and external livestream links.

Out of scope: online payment, e-wallet, internal chat, automatic refunds, direct bank transaction management, separate referee/player/organizer roles and livestream infrastructure operated by Soccer Booker.

## 2. Product Overview
User finds/books pitches and follows tournaments. Pitch Owner manages pitches, schedules, prices, bookings, feedback, tournaments, matches, livestream links and revenue.

## 3. Roles
### User
Register/login/logout/update account; search/filter/nearby pitch; view pitch and schedule; create/cancel booking; view booking history/statistics; feedback; view/register tournaments; view teams/matches/results/standings/player statistics; comment where allowed; open livestream links.

### Pitch Owner
All relevant account functions plus pitch CRUD/deactivation, price/deposit/service-fee settings, opening hours/slots/schedules, booking approval/rejection/cancellation, feedback viewing, promotion content, tournament/team/match/result management, livestream link and revenue statistics.

## 4. Functional Requirements

### 4.1 Authentication
| ID | Requirement | Priority |
|---|---|---|
| FR-AUTH-001 | Register with full name, email, phone, password. | Must |
| FR-AUTH-002 | User/Pitch Owner login with valid account. | Must |
| FR-AUTH-003 | Logout. | Must |
| FR-AUTH-004 | Update personal information. | Must |

### 4.2 Pitch
| ID | Requirement | Priority |
|---|---|---|
| FR-PITCH-001 | Search by pitch name, area, location. | Must |
| FR-PITCH-002 | Find nearby pitches using browser location or selected area. | Must |
| FR-PITCH-003 | Filter by area, distance, price, date, time, type, amenities, rating, availability. | Must |
| FR-PITCH-004 | Show matching pitch list. | Must |
| FR-PITCH-005 | View pitch details. | Must |
| FR-PITCH-006 | View daily schedule and slot status. | Must |
| FR-PITCH-007 | Pitch Owner updates slot status. | Must |

### 4.3 Booking
| ID | Requirement | Priority |
|---|---|---|
| FR-BOOK-001 | Logged-in User creates booking request. | Must |
| FR-BOOK-002 | Check availability and prevent duplicate booking. | Must |
| FR-BOOK-003 | Support PENDING, WAITING_FOR_DEPOSIT, CONFIRMED, REJECTED, CANCELLED, EXPIRED, COMPLETED. | Must |
| FR-BOOK-004 | Owner views and approves/rejects booking. | Must |
| FR-BOOK-005 | Show deposit amount, bank information, QR if provided and transfer instructions. | Must |
| FR-BOOK-006 | User confirms external transfer. | Must |
| FR-BOOK-007 | Owner verifies transfer notice and confirms booking. | Must |
| FR-BOOK-008 | Unconfirmed deposit after 4 hours becomes EXPIRED and releases slot. | Must |
| FR-BOOK-009 | User cancels booking according to deposit policy. | Must |
| FR-BOOK-010 | Owner cancels with reason; refund is external. | Must |
| FR-BOOK-011 | User views current/completed/cancelled/expired bookings. | Must |
| FR-BOOK-012 | Booking statistics: total/completed/cancelled/expired. | Must |
| FR-BOOK-013 | Warn Owner about high cancellation history; never auto-ban User. | Should |

### 4.4 Feedback
| ID | Requirement | Priority |
|---|---|---|
| FR-FEEDBACK-001 | User rates pitch after booking completion. | Must |
| FR-FEEDBACK-002 | Feedback has rating, content and optional images. | Must |
| FR-FEEDBACK-003 | One feedback per completed booking. | Must |
| FR-FEEDBACK-004 | User/Owner views appropriate feedback. | Must |
| FR-FEEDBACK-005 | Calculate pitch average rating. | Must |

### 4.5 Tournament
| ID | Requirement | Priority |
|---|---|---|
| FR-TOUR-001 | Owner creates tournament. | Must |
| FR-TOUR-002 | Owner updates managed tournament. | Must |
| FR-TOUR-003 | Owner cancels/deletes tournament when allowed. | Must |
| FR-TOUR-004 | User views tournament list/details. | Must |
| FR-TOUR-005 | User registers while registration is open. | Must |
| FR-TOUR-006 | Owner manages participating teams. | Must |
| FR-TOUR-007 | Calculate standings from match results. | Must |
| FR-TOUR-008 | Show player statistics supplied by Owner. | Should |
| FR-TOUR-009 | Track goals and top scorers. | Should |

### 4.6 Match
| ID | Requirement | Priority |
|---|---|---|
| FR-MATCH-001 | Owner creates match schedule. | Must |
| FR-MATCH-002 | Prevent two matches on same pitch at overlapping time. | Must |
| FR-MATCH-003 | Owner enters/updates result. | Must |
| FR-MATCH-004 | User views teams, time, pitch, result and status. | Must |

### 4.7 Comment & Livestream
| ID | Requirement | Priority |
|---|---|---|
| FR-COMMENT-001 | User comments in allowed areas. | Should |
| FR-COMMENT-002 | Show comments relevant to viewed content. | Should |
| FR-LIVE-001 | Owner provides external livestream URL. | Should |
| FR-LIVE-002 | User opens livestream from match page. | Should |

### 4.8 Pitch Owner
| ID | Requirement | Priority |
|---|---|---|
| FR-OWNER-001 | Owner updates contact information. | Must |
| FR-OWNER-002 | Owner adds pitch. | Must |
| FR-OWNER-003 | Owner edits managed pitch. | Must |
| FR-OWNER-004 | Owner deletes/deactivates pitch under appropriate conditions. | Must |
| FR-OWNER-005 | Manage pitch price, time-based price, deposit and service fee. | Must |
| FR-OWNER-006 | Manage opening hours and bookable slots. | Must |
| FR-OWNER-007 | Manage pitch schedule to avoid conflicts. | Must |
| FR-OWNER-008 | Provide promotional pitch content. | Should |

### 4.9 Revenue
| ID | Requirement | Priority |
|---|---|---|
| FR-REVENUE-001 | Owner tracks revenue statistics from recorded bookings. | Must |

## 5. Business Rules
- BR-001: no two valid bookings for the same pitch/time.
- BR-002: login required before booking.
- BR-003: booking becomes official after Owner confirmation process.
- BR-004/005: deposit is transferred directly outside Soccer Booker; no payment processing.
- BR-006: incomplete deposit confirmation after 4 hours expires booking.
- BR-007: User cancellation after deposit is non-refundable.
- BR-008: Owner cancellation after deposit requires external refund.
- BR-009: no automatic User ban from cancellation history.
- BR-010: Owner may receive high-cancellation warning.
- BR-011: feedback only after completed booking.
- BR-012/013/014: Owner manages tournament; User may view/allowed-interact but cannot edit management data.
- BR-015: no overlapping tournament matches on one pitch.
- BR-016: standings are calculated from recorded match results.

## 6. Non-Functional Requirements
| ID | Requirement |
|---|---|
| NFR-01 | 100% Must-have functions implemented and traced. |
| NFR-02 | API p95 ≤ 500 ms under defined load. |
| NFR-03 | Main-page LCP ≤ 2.5 s on emulated 4G. |
| NFR-04 | ≥200 concurrent users while meeting NFR-02. |
| NFR-05 | Two latest versions of Chrome, Edge, Firefox, Safari. |
| NFR-06 | Public APIs documented in OpenAPI 3.x and contract compliant. |
| NFR-07 | ≥90% test users complete booking within 5 minutes. |
| NFR-08 | Correct display of all 7 booking states. |
| NFR-09 | Availability ≥99.9% per month. |
| NFR-10 | Booking errors never create duplicate/invalid bookings. |
| NFR-11 | Backup at most every 24h; RTO ≤4h. |
| NFR-12 | HTTPS/TLS; salted one-way password hashing; no plaintext. |
| NFR-13 | Protected APIs reject invalid/expired/missing authentication. |
| NFR-14 | Important data changes have actor + timestamp audit logs retained ≥12 months. |
| NFR-15 | DB prevents two valid bookings for same pitch/date/time under concurrency. |
| NFR-16 | Modular architecture with no circular dependencies between main business modules. |
| NFR-17 | Service unit-test coverage ≥70%; CI runs tests on PR. |
| NFR-18 | Coding convention; CI has no serious build/lint errors. |
| NFR-19 | Docker Compose setup; environment variables instead of hard-coded environment secrets. |

## 7. Data Requirements
User, PitchOwner, Pitch, PitchSchedule, Booking, Deposit, Feedback, Tournament, Player, Team, Match, MatchResult, Standing, Comment, Livestream, Revenue.

## 8. External Interfaces
Responsive web UI for desktop/laptop/tablet/mobile; browser geolocation with User permission; external bank-transfer instructions (account, bank, QR, instructions). No direct bank/payment-gateway integration.

## 9. Use Cases
The following UC identifiers are derived from the SRS FR catalog and its booking/tournament flows for traceability.

| UC | Name | Actors | Main FR |
|---|---|---|---|
| UC-01 | Register/Login/Manage Account | User, Owner | AUTH-001..004 |
| UC-02 | Search, Filter & View Pitch Schedule | User, Owner | PITCH-001..007 |
| UC-03 | Create & Process Booking | User, Owner | BOOK-001..013 |
| UC-04 | Feedback & Rating | User, Owner | FEEDBACK-001..005 |
| UC-05 | Manage Tournament | Owner, User | TOUR-001..006 |
| UC-06 | Schedule Match & Record Result | Owner, User | MATCH-001..004 |
| UC-07 | Tournament Statistics & Standings | User, Owner | TOUR-007..009 |
| UC-08 | Comment & Livestream | User, Owner | COMMENT-001..002, LIVE-001..002 |
| UC-09 | Manage Pitch & Revenue | Owner | OWNER-001..008, REVENUE-001 |

### UC-03 Booking flow
Login → search pitch → choose date/slot → create booking → Owner approves/rejects → WAITING_FOR_DEPOSIT → external transfer → User notifies → Owner verifies → CONFIRMED → use pitch → COMPLETED. User/Owner may cancel; waiting deposit can become EXPIRED after 4 hours.

### UC-05/06 Tournament flow
Owner creates tournament → opens registration → User registers → Owner manages teams → creates matches → matches are played → Owner records results → system updates standings/statistics.

## 10. Acceptance Criteria
1. Register/login works.
2. Search/filter/nearby pitch works.
3. Schedule can be viewed.
4. Booking can be created and duplicates prevented.
5. Owner can approve/reject/cancel.
6. External deposit flow is recorded.
7. Four-hour timeout creates EXPIRED.
8. Booking history/statistics are available.
9. Feedback is available after completion and only once per booking.
10. Owner manages pitch, price, slots and tournament.
11. User can view/register tournament.
12. Owner can schedule matches and update results.
13. Standings/top scorers are available.
14. Owner can provide livestream URL and User can open it.
15. User cannot edit tournament management data.

## 11. Future Scope
Online payment, automatic bank confirmation/refunds, internal chat, push notifications, mobile app, dedicated referee/team/player management, livestream integration, vouchers/membership, recommendations, anomaly detection and automatic banning.

## 12. Glossary
User, Pitch Owner, Pitch, Booking, Deposit, Tournament, Team, Match, Standing, Feedback, Livestream, plus the seven booking states defined above.
