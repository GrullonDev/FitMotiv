-- ============================================
-- FitMotiv — Supabase Database Schema
-- Run this in the Supabase SQL Editor
-- ============================================

-- ─────────────────────────────────────────────
-- 1. Exercises Table (linked to workouts)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS exercises (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT DEFAULT '',
  category TEXT DEFAULT 'General',
  seconds INT,          -- NULL means reps-based
  reps INT,             -- NULL means time-based
  rest_seconds INT DEFAULT 15,
  sort_order INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

-- Everyone can read exercises (they belong to public workouts)
CREATE POLICY "Anyone can read exercises"
  ON exercises FOR SELECT
  USING (true);

-- Only authenticated users can insert exercises
CREATE POLICY "Authenticated users can insert exercises"
  ON exercises FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ─────────────────────────────────────────────
-- 2. Meal Plans Table
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meal_plans (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  calories TEXT DEFAULT '',
  icon TEXT DEFAULT 'restaurant',
  badge_text TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  is_recommended BOOLEAN DEFAULT false,
  is_public BOOLEAN DEFAULT true,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read public meal plans"
  ON meal_plans FOR SELECT
  USING (is_public = true);

CREATE POLICY "Authenticated users can insert meal plans"
  ON meal_plans FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ─────────────────────────────────────────────
-- 3. Recipes Table
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS recipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  time TEXT DEFAULT '',
  calories TEXT DEFAULT '',
  category TEXT DEFAULT 'General',
  image_url TEXT DEFAULT '',
  rating DOUBLE PRECISION DEFAULT 0,
  ingredients TEXT[] DEFAULT '{}',
  instructions TEXT DEFAULT '',
  is_public BOOLEAN DEFAULT true,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read public recipes"
  ON recipes FOR SELECT
  USING (is_public = true);

CREATE POLICY "Authenticated users can insert recipes"
  ON recipes FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ─────────────────────────────────────────────
-- 4. Tips Table
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  color TEXT DEFAULT '#3B82F6',
  category TEXT DEFAULT 'general',
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE tips ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read public tips"
  ON tips FOR SELECT
  USING (is_public = true);

-- ─────────────────────────────────────────────
-- 5. Articles Table
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS articles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT DEFAULT '',
  content TEXT DEFAULT '',
  read_time TEXT DEFAULT '5 min',
  category TEXT DEFAULT 'nutrition',
  image_url TEXT DEFAULT '',
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read public articles"
  ON articles FOR SELECT
  USING (is_public = true);

-- ─────────────────────────────────────────────
-- 6. Water Log Table (per-user daily tracking)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS water_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  glasses INT DEFAULT 0,
  date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, date)
);

ALTER TABLE water_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own water log"
  ON water_log FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own water log"
  ON water_log FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own water log"
  ON water_log FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ─────────────────────────────────────────────
-- 7. Seed Data — Sample Exercises for Workouts
-- ─────────────────────────────────────────────
-- NOTE: Run this after creating workouts in the 'workouts' table.
-- The workout_id values below are placeholders; replace them
-- with actual UUIDs from your workouts table.

-- Example:
-- INSERT INTO exercises (workout_id, name, description, seconds, sort_order) VALUES
--   ('YOUR_WORKOUT_UUID', 'Push Ups', 'Standard push ups for upper body strength', 60, 1),
--   ('YOUR_WORKOUT_UUID', 'Squats', 'Bodyweight squats for lower body', 45, 2);

-- ─────────────────────────────────────────────
-- 8. Seed Data — Sample Recipes
-- ─────────────────────────────────────────────
INSERT INTO recipes (title, description, time, calories, category, image_url, rating) VALUES
  ('Tostada de Aguacate', 'Un desayuno nutritivo y delicioso para empezar bien el día.', '15 min', '320 kcal', 'Vegano', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=500&auto=format&fit=crop', 4.8),
  ('Ensalada de Quinoa', 'Rica en proteínas y fibra, perfecta para después del entrenamiento.', '20 min', '450 kcal', 'Vegano', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop', 4.6),
  ('Batido de Frutos Rojos', 'Antioxidantes naturales en un batido refrescante.', '5 min', '250 kcal', 'Vegano', 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=500&auto=format&fit=crop', 4.9),
  ('Salmón a la Parrilla', 'Rico en omega-3 con vegetales asados.', '25 min', '550 kcal', 'Alta Proteína', 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=500&auto=format&fit=crop', 4.7)
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────────
-- 9. Seed Data — Sample Meal Plans
-- ─────────────────────────────────────────────
INSERT INTO meal_plans (title, description, calories, icon, badge_text, image_url, is_recommended) VALUES
  ('Plan Para Bajar de Peso', 'Plan de alimentación balanceado diseñado para perder grasa de forma saludable.', '1,500 - 1,800 kcal', 'restaurant', '7 días', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=500&auto=format&fit=crop', true),
  ('Plan Ganancia Muscular', 'Plan alto en proteínas para apoyar el crecimiento muscular.', '2,500 - 3,000 kcal', 'fitness_center', 'Avanzado', 'https://images.unsplash.com/photo-1532384748853-8f54a8f476e2?q=80&w=500&auto=format&fit=crop', false),
  ('Plan Keto', 'Dieta cetogénica baja en carbohidratos para una rápida quema de grasa.', '1,800 - 2,200 kcal', 'eco', 'Popular', 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=500&auto=format&fit=crop', false)
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────────
-- 10. Seed Data — Tips & Articles  
-- ─────────────────────────────────────────────
INSERT INTO tips (title, description, color) VALUES
  ('Mito: Los carbohidratos después de las 6 PM engordan.', 'Realidad: El balance calórico total del día es lo que importa.', '#3B82F6'),
  ('Mito: Beber agua con limón quema grasa.', 'Realidad: El agua con limón hidrata, pero no tiene propiedades quema grasa.', '#F59E0B'),
  ('Mito: Las pesas hacen que las mujeres se vean masculinas.', 'Realidad: El entrenamiento de fuerza tonifica y mejora la composición corporal.', '#10B981')
ON CONFLICT DO NOTHING;

INSERT INTO articles (title, subtitle, read_time, category) VALUES
  ('Cómo leer etiquetas nutricionales', 'Aprende a diferenciar el marketing de la realidad.', '5 min', 'nutrition'),
  ('La importancia de la hidratación', 'Por qué el agua es tu mejor aliada en el gym.', '4 min', 'nutrition'),
  ('Mejores snacks pre-entreno', 'Energía real para tus músculos.', '3 min', 'nutrition')
ON CONFLICT DO NOTHING;
