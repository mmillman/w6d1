require 'active_support/inflector'
require_relative 'has_many_params'
require_relative 'belongs_to_params'

module Associatable
  def belongs_to(name, params = {})
    define_method(name) do
      aps = BelongsToParams.new(self, name, params)

      query = <<-SQL
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.primary_key} = ?
      SQL

      row_hash = DBConnection.execute(query, self.send(aps.primary_key))

      aps.other_class.parse_all(row_hash).first
    end
  end

  def has_many(name, params = {})
    aps = HasManyParams.new(self, name, params)

    define_method(name) do
      query = <<-SQL
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.foreign_key} = ?
      SQL

      row_hashes = DBConnection.execute(query, self.send(aps.primary_key))

      aps.other_class.parse_all(row_hashes)
    end
  end
end