require 'active_support/inflector'
require_relative 'has_many_assoc_params'

module Associatable
  def belongs_to(name, params = {})
    define_method(name) do
      other_class = (if params[:class_name]
        params[:class_name]
      else
        "#{name}".camelize
      end).constantize

      other_table_name = other_class.table_name

      primary_key = params[:primary_key] ? params[:primary_key] : "id"

      foreign_key = (if params[:foreign_key]
        params[:foreign_key]
      else
        "#{name}_id"
      end)

      query = <<-SQL
        SELECT *
          FROM #{other_table_name}
         WHERE #{other_table_name}.#{primary_key} = ?
      SQL

      row_hash = DBConnection.execute(query, self.send("#{foreign_key}"))

      other_class.parse_all(row_hash).first
    end
  end

  def has_many(name, params = {})
    aps = HasManyAssocParams.new(self, name, params)

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