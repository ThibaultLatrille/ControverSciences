class AddUnaccentAndTrgmToPostgresql < ActiveRecord::Migration
  def change
    enable_extension "unaccent"
    enable_extension "pg_trgm"
  end
end
