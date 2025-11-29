-- OpenWardrobe Initial Schema
-- Creates all tables needed for the wardrobe management app

-- ============================================
-- Categories table (for clothing categories)
-- ============================================
CREATE TABLE item_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert some default categories
INSERT INTO item_categories (name) VALUES 
  ('Tops'),
  ('Bottoms'),
  ('Dresses'),
  ('Outerwear'),
  ('Shoes'),
  ('Accessories'),
  ('Activewear'),
  ('Formal'),
  ('Swimwear'),
  ('Underwear');

-- ============================================
-- Brands table
-- ============================================
CREATE TABLE brands (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(name, user_id)
);

-- ============================================
-- Wardrobe items table
-- ============================================
CREATE TABLE wardrobe (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
  category_id UUID REFERENCES item_categories(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Outfits table
-- ============================================
CREATE TABLE outfits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  wardrobe_item_ids UUID[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Enable Row Level Security on all user tables
-- ============================================
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE wardrobe ENABLE ROW LEVEL SECURITY;
ALTER TABLE outfits ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS Policies - Users can only access their own data
-- ============================================

-- Brands policies
CREATE POLICY "Users can view own brands" 
  ON brands FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own brands" 
  ON brands FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own brands" 
  ON brands FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own brands" 
  ON brands FOR DELETE 
  USING (auth.uid() = user_id);

-- Wardrobe policies
CREATE POLICY "Users can view own wardrobe" 
  ON wardrobe FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own wardrobe items" 
  ON wardrobe FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own wardrobe items" 
  ON wardrobe FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own wardrobe items" 
  ON wardrobe FOR DELETE 
  USING (auth.uid() = user_id);

-- Outfits policies
CREATE POLICY "Users can view own outfits" 
  ON outfits FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own outfits" 
  ON outfits FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own outfits" 
  ON outfits FOR UPDATE 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own outfits" 
  ON outfits FOR DELETE 
  USING (auth.uid() = user_id);

-- Categories are public (read-only for all authenticated users)
ALTER TABLE item_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view categories" 
  ON item_categories FOR SELECT 
  TO authenticated
  USING (true);

-- ============================================
-- Updated_at trigger function
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_wardrobe_updated_at
  BEFORE UPDATE ON wardrobe
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_outfits_updated_at
  BEFORE UPDATE ON outfits
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

