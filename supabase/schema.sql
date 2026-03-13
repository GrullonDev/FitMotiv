-- ============================================================
-- FitMotiv: Supabase Database Schema
-- Run this SQL in your Supabase SQL Editor
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. PROFILES TABLE
-- Stores public profile info synced from auth.users metadata
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  username TEXT UNIQUE,
  bio TEXT DEFAULT '',
  fitness_goal TEXT DEFAULT '',
  activity_level TEXT DEFAULT '',
  age INTEGER DEFAULT 0,
  height DOUBLE PRECISION DEFAULT 0.0,
  weight DOUBLE PRECISION DEFAULT 0.0,
  avatar_url TEXT DEFAULT '',
  is_online BOOLEAN DEFAULT false,
  last_seen TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Everyone can read profiles (for community features)
CREATE POLICY "Public profiles are visible to everyone"
  ON public.profiles FOR SELECT
  USING (true);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- ────────────────────────────────────────────────────────────
-- Trigger: Auto-create profile on user signup
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, username, bio, fitness_goal, activity_level, age, height, weight)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'username', ''),
    COALESCE(NEW.raw_user_meta_data->>'bio', ''),
    COALESCE(NEW.raw_user_meta_data->>'fitness_goal', ''),
    COALESCE(NEW.raw_user_meta_data->>'activity_level', ''),
    COALESCE((NEW.raw_user_meta_data->>'age')::INTEGER, 0),
    COALESCE((NEW.raw_user_meta_data->>'height')::DOUBLE PRECISION, 0.0),
    COALESCE((NEW.raw_user_meta_data->>'weight')::DOUBLE PRECISION, 0.0)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ────────────────────────────────────────────────────────────
-- 2. WORKOUTS TABLE
-- Exercise routines/workouts
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT DEFAULT '',
  duration INTEGER DEFAULT 0,
  difficulty TEXT DEFAULT 'Beginner',
  category TEXT DEFAULT 'General',
  equipment TEXT[] DEFAULT '{}',
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;

-- Users can see public workouts and their own
CREATE POLICY "Users can view public and own workouts"
  ON public.workouts FOR SELECT
  USING (is_public = true OR auth.uid() = user_id);

-- Users can create their own workouts
CREATE POLICY "Users can create own workouts"
  ON public.workouts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own workouts
CREATE POLICY "Users can update own workouts"
  ON public.workouts FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own workouts
CREATE POLICY "Users can delete own workouts"
  ON public.workouts FOR DELETE
  USING (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 3. WORKOUT SESSIONS TABLE
-- Records of completed workout sessions
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.workout_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  workout_id UUID REFERENCES public.workouts(id) ON DELETE SET NULL,
  workout_name TEXT NOT NULL,
  duration_minutes INTEGER DEFAULT 0,
  calories_burned INTEGER DEFAULT 0,
  notes TEXT DEFAULT '',
  completed_at TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own sessions"
  ON public.workout_sessions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own sessions"
  ON public.workout_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 4. WEIGHT LOG TABLE
-- User weight tracking over time
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.weight_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  weight DOUBLE PRECISION NOT NULL,
  notes TEXT DEFAULT '',
  recorded_at TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.weight_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own weight log"
  ON public.weight_log FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own weight log"
  ON public.weight_log FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own weight log"
  ON public.weight_log FOR DELETE
  USING (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 5. GOALS TABLE
-- User fitness goals
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.goals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  target_value DOUBLE PRECISION DEFAULT 0,
  current_value DOUBLE PRECISION DEFAULT 0,
  unit TEXT DEFAULT '',
  icon TEXT DEFAULT 'flag',
  is_completed BOOLEAN DEFAULT false,
  deadline TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own goals"
  ON public.goals FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own goals"
  ON public.goals FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own goals"
  ON public.goals FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own goals"
  ON public.goals FOR DELETE
  USING (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 6. COMMUNITY POSTS TABLE
-- Social feed posts
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

-- Everyone can read posts
CREATE POLICY "Posts are public"
  ON public.posts FOR SELECT
  USING (true);

CREATE POLICY "Users can create own posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- 7. MOTIVATIONAL QUOTES TABLE
-- Citas motivacionales
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.quotes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  text TEXT NOT NULL,
  author TEXT DEFAULT '',
  category TEXT DEFAULT 'general',
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.quotes ENABLE ROW LEVEL SECURITY;

-- Everyone can read quotes
CREATE POLICY "Quotes are public"
  ON public.quotes FOR SELECT
  USING (true);

-- Insert seed quotes
INSERT INTO public.quotes (text, author, category) VALUES
  ('The only bad workout is the one that didn''t happen.', 'Unknown', 'workout'),
  ('Your body can do it. It''s your mind you need to convince.', 'Unknown', 'motivation'),
  ('Fitness is not about being better than someone else. It''s about being better than you used to be.', 'Khloe Kardashian', 'fitness'),
  ('The groundwork for all happiness is good health.', 'Leigh Hunt', 'health'),
  ('Take care of your body. It''s the only place you have to live.', 'Jim Rohn', 'health'),
  ('Every workout is progress, no matter how small.', 'Unknown', 'workout'),
  ('Strong is the new beautiful.', 'Unknown', 'motivation'),
  ('Your only limit is you.', 'Unknown', 'motivation'),
  ('The pain you feel today will be the strength you feel tomorrow.', 'Arnold Schwarzenegger', 'workout'),
  ('Don''t wish for a good body, work for it.', 'Unknown', 'motivation');

-- Insert default public workouts
INSERT INTO public.workouts (name, description, duration, difficulty, category, equipment, is_public) VALUES
  ('Quick Cardio Blast', 'Get your heart pumping with this high-intensity workout.', 15, 'Intermediate', 'Cardio', ARRAY['None'], true),
  ('Strength Builder', 'Build lean muscle with this focused strength training session.', 30, 'Beginner', 'Strength', ARRAY['Dumbbells'], true),
  ('Yoga Flow', 'Relax and stretch with this gentle yoga sequence.', 20, 'Beginner', 'Flexibility', ARRAY['Yoga Mat'], true),
  ('HIIT Extreme', 'Push your limits with this high-intensity interval session.', 25, 'Advanced', 'Cardio', ARRAY['None'], true),
  ('Full Body Burn', 'Complete full-body workout targeting all major muscle groups.', 45, 'Intermediate', 'Full Body', ARRAY['Dumbbells', 'Resistance Bands'], true),
  ('Core Crusher', 'Strengthen your core with these targeted exercises.', 20, 'Intermediate', 'Core', ARRAY['Yoga Mat'], true);
