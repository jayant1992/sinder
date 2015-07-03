class ChangeNameTypeInTags < ActiveRecord::Migration
  def up
    change_column(:tags, :name, :string, :unique => true)
  end

  def down
    change_column(:tags, :name, :string)
  end
end
