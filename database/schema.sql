-- Soccer Booker v1.0 | PostgreSQL 15+
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$ BEGIN CREATE TYPE user_role AS ENUM ('USER','PITCH_OWNER'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE TYPE booking_status AS ENUM ('PENDING','WAITING_FOR_DEPOSIT','CONFIRMED','REJECTED','CANCELLED','EXPIRED','COMPLETED'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS users (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 full_name VARCHAR(150) NOT NULL,
 email VARCHAR(255) NOT NULL UNIQUE,
 phone VARCHAR(30) NOT NULL UNIQUE,
 password_hash TEXT NOT NULL,
 role user_role NOT NULL DEFAULT 'USER',
 facebook_url TEXT, other_contact TEXT,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS pitches (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 owner_id UUID NOT NULL REFERENCES users(id),
 name VARCHAR(200) NOT NULL, address TEXT NOT NULL, area VARCHAR(150),
 latitude NUMERIC(9,6), longitude NUMERIC(9,6), pitch_type VARCHAR(80),
 description TEXT, amenities JSONB NOT NULL DEFAULT '[]'::jsonb,
 image_urls JSONB NOT NULL DEFAULT '[]'::jsonb,
 contact_phone VARCHAR(30),
 status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE','DELETED')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS pitch_payment_settings (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 pitch_id UUID NOT NULL UNIQUE REFERENCES pitches(id) ON DELETE CASCADE,
 bank_name VARCHAR(150), account_name VARCHAR(200), account_number VARCHAR(100),
 qr_code_url TEXT, deposit_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (deposit_amount >= 0),
 service_fee NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (service_fee >= 0), transfer_instruction TEXT
);

CREATE TABLE IF NOT EXISTS pitch_schedules (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 pitch_id UUID NOT NULL REFERENCES pitches(id) ON DELETE CASCADE,
 schedule_date DATE NOT NULL, start_time TIME NOT NULL, end_time TIME NOT NULL,
 status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE','BOOKED','UNAVAILABLE')),
 CHECK (start_time < end_time), UNIQUE (pitch_id,schedule_date,start_time,end_time)
);

CREATE TABLE IF NOT EXISTS bookings (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 user_id UUID NOT NULL REFERENCES users(id), pitch_id UUID NOT NULL REFERENCES pitches(id),
 schedule_id UUID NOT NULL REFERENCES pitch_schedules(id),
 status booking_status NOT NULL DEFAULT 'PENDING',
 amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (amount >= 0),
 service_fee NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (service_fee >= 0),
 deposit_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (deposit_amount >= 0),
 cancellation_reason TEXT, deposit_notified_at TIMESTAMPTZ,
 confirmed_at TIMESTAMPTZ, expires_at TIMESTAMPTZ, completed_at TIMESTAMPTZ,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_active_booking_schedule ON bookings(schedule_id)
 WHERE status IN ('PENDING','WAITING_FOR_DEPOSIT','CONFIRMED');
CREATE INDEX IF NOT EXISTS idx_bookings_user_status ON bookings(user_id,status);
CREATE INDEX IF NOT EXISTS idx_bookings_expiry ON bookings(status,expires_at);

CREATE TABLE IF NOT EXISTS deposits (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), booking_id UUID NOT NULL UNIQUE REFERENCES bookings(id) ON DELETE CASCADE,
 amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0), bank_name VARCHAR(150), account_name VARCHAR(200),
 account_number VARCHAR(100), qr_code_url TEXT, instruction TEXT,
 user_notified_at TIMESTAMPTZ, owner_verified_at TIMESTAMPTZ,
 status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','USER_NOTIFIED','VERIFIED','REJECTED'))
);

CREATE TABLE IF NOT EXISTS feedback (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), booking_id UUID NOT NULL UNIQUE REFERENCES bookings(id) ON DELETE CASCADE,
 user_id UUID NOT NULL REFERENCES users(id), pitch_id UUID NOT NULL REFERENCES pitches(id),
 rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5), content TEXT,
 image_urls JSONB NOT NULL DEFAULT '[]'::jsonb, created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS tournaments (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), owner_id UUID NOT NULL REFERENCES users(id),
 name VARCHAR(200) NOT NULL, description TEXT, start_at TIMESTAMPTZ, end_at TIMESTAMPTZ,
 location TEXT, pitch_id UUID REFERENCES pitches(id), format VARCHAR(100),
 max_teams INTEGER CHECK (max_teams IS NULL OR max_teams > 0),
 registration_open_at TIMESTAMPTZ, registration_close_at TIMESTAMPTZ, contact_info TEXT, image_url TEXT,
 status VARCHAR(30) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT','OPEN','IN_PROGRESS','COMPLETED','CANCELLED')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(), updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 CHECK (registration_close_at IS NULL OR registration_open_at IS NULL OR registration_open_at <= registration_close_at)
);

CREATE TABLE IF NOT EXISTS teams (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
 name VARCHAR(150) NOT NULL, captain_user_id UUID REFERENCES users(id),
 status VARCHAR(30) NOT NULL DEFAULT 'REGISTERED' CHECK (status IN ('REGISTERED','APPROVED','REJECTED','WITHDRAWN')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(), UNIQUE(tournament_id,name)
);

CREATE TABLE IF NOT EXISTS tournament_registrations (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
 user_id UUID NOT NULL REFERENCES users(id), team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
 registered_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 status VARCHAR(30) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED','CANCELLED')),
 UNIQUE(tournament_id,user_id)
);

CREATE TABLE IF NOT EXISTS players (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
 name VARCHAR(150) NOT NULL, shirt_number INTEGER CHECK (shirt_number IS NULL OR shirt_number BETWEEN 0 AND 99),
 position VARCHAR(80), goals INTEGER NOT NULL DEFAULT 0 CHECK (goals >= 0),
 assists INTEGER NOT NULL DEFAULT 0 CHECK (assists >= 0), stats JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS matches (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
 pitch_id UUID NOT NULL REFERENCES pitches(id), team_a_id UUID NOT NULL REFERENCES teams(id),
 team_b_id UUID NOT NULL REFERENCES teams(id), scheduled_at TIMESTAMPTZ NOT NULL, end_at TIMESTAMPTZ,
 round_name VARCHAR(100), status VARCHAR(30) NOT NULL DEFAULT 'SCHEDULED'
 CHECK (status IN ('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED')),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(), CHECK (team_a_id <> team_b_id),
 CHECK (end_at IS NULL OR end_at > scheduled_at)
);

CREATE OR REPLACE FUNCTION prevent_match_overlap() RETURNS trigger AS $$
BEGIN
 IF EXISTS (
  SELECT 1 FROM matches m
  WHERE m.pitch_id=NEW.pitch_id AND m.id<>NEW.id AND m.status<>'CANCELLED'
  AND tstzrange(m.scheduled_at,COALESCE(m.end_at,m.scheduled_at+interval '2 hours'),'[)')
      && tstzrange(NEW.scheduled_at,COALESCE(NEW.end_at,NEW.scheduled_at+interval '2 hours'),'[)')
 ) THEN RAISE EXCEPTION 'MATCH_PITCH_TIME_CONFLICT'; END IF;
 RETURN NEW;
END; $$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_prevent_match_overlap ON matches;
CREATE TRIGGER trg_prevent_match_overlap BEFORE INSERT OR UPDATE OF pitch_id,scheduled_at,end_at,status
ON matches FOR EACH ROW EXECUTE FUNCTION prevent_match_overlap();

CREATE TABLE IF NOT EXISTS match_results (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), match_id UUID NOT NULL UNIQUE REFERENCES matches(id) ON DELETE CASCADE,
 team_a_score INTEGER NOT NULL DEFAULT 0 CHECK (team_a_score >= 0),
 team_b_score INTEGER NOT NULL DEFAULT 0 CHECK (team_b_score >= 0),
 recorded_by UUID NOT NULL REFERENCES users(id), recorded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS standings (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
 team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE, played INTEGER NOT NULL DEFAULT 0 CHECK (played >= 0),
 won INTEGER NOT NULL DEFAULT 0 CHECK (won >= 0), drawn INTEGER NOT NULL DEFAULT 0 CHECK (drawn >= 0),
 lost INTEGER NOT NULL DEFAULT 0 CHECK (lost >= 0), goals_for INTEGER NOT NULL DEFAULT 0 CHECK (goals_for >= 0),
 goals_against INTEGER NOT NULL DEFAULT 0 CHECK (goals_against >= 0), goal_difference INTEGER NOT NULL DEFAULT 0,
 points INTEGER NOT NULL DEFAULT 0 CHECK (points >= 0), updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 UNIQUE(tournament_id,team_id)
);

CREATE TABLE IF NOT EXISTS comments (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 tournament_id UUID REFERENCES tournaments(id) ON DELETE CASCADE, match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
 content TEXT NOT NULL CHECK (length(trim(content)) > 0), created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 CHECK (tournament_id IS NOT NULL OR match_id IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS livestreams (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), match_id UUID NOT NULL UNIQUE REFERENCES matches(id) ON DELETE CASCADE,
 url TEXT NOT NULL, provided_by UUID NOT NULL REFERENCES users(id), created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS revenues (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), pitch_id UUID NOT NULL REFERENCES pitches(id),
 booking_id UUID NOT NULL UNIQUE REFERENCES bookings(id), owner_id UUID NOT NULL REFERENCES users(id),
 amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0), recorded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit_logs (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(), actor_user_id UUID REFERENCES users(id),
 action VARCHAR(100) NOT NULL, entity_type VARCHAR(100) NOT NULL, entity_id UUID,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_feedback_pitch ON feedback(pitch_id);
CREATE INDEX IF NOT EXISTS idx_tournament_owner ON tournaments(owner_id);
CREATE INDEX IF NOT EXISTS idx_comments_tournament ON comments(tournament_id,created_at);
CREATE INDEX IF NOT EXISTS idx_comments_match ON comments(match_id,created_at);
CREATE INDEX IF NOT EXISTS idx_revenue_owner_date ON revenues(owner_id,recorded_at);
CREATE INDEX IF NOT EXISTS idx_audit_created_at ON audit_logs(created_at);

-- Payment/refund remain outside Soccer Booker. Booking expiry and standings are application/scheduler responsibilities.
