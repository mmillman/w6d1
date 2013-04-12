class Goofy

  @count = 0

  def self.new
    @count += 1

    super
  end

  def do_some_stuff(methods)
    methods.each do |method|
      send(method)
    end
  end

  def self.teach_goofy_to_say_something(lesson)
    define_method(lesson[0]) do
      puts lesson[1]
    end
  end

  def self.count
    @count
  end

  private
  def say_hello
    puts 'Huh huh, hey evaray-body!'
  end
end