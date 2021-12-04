class AddCachedVotesToDogs < ActiveRecord::Migration[5.2]
  def change
    change_table :dogs do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
    end
  end
end
