class HasManyAssocParams
  def initialize(name, params)
    @name = name
    @params = params
  end

  def other_class
    (if @params[:class_name]
      @params[:class_name]
    else
      "#{@name}".singularize.camelize
    end).constantize
  end

  def other_table
    other_class.table_name
  end

  def primary_key
    @params[:primary_key] ? @params[:primary_key] : "id"
  end

  def foreign_key
    if @params[:foreign_key]
      @params[:foreign_key]
    else
      p "hissss"
      "#{self.class.underscore}_id"
    end
  end
end