class Factory
  def self.new(*args, &block)
    klass = Class.new do
      attr_accessor *args

      define_method :initialize do |*each_arg|
        each_arg.each_with_index do |value, index|
          send("#{args[index]}=", value)
        end
      end

      define_method :[] do |value|
        var = value if value.is_a? String
        var = value if value.is_a? Symbol
        var = args[value] if value.is_a? Integer
        send("#{var}")
      end
    end
    klass.class_eval &block if block_given?
    klass
  end
end

Customer = Factory.new(:name, :address, :zip)

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)

p joe.name    # => "Joe Smith"
p joe['name'] # => "Joe Smith"
p joe[:name]  # => "Joe Smith"
p joe[0]      # => "Joe Smith"

customer = Factory.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end

p customer.new('Dave', '123 Main').greeting
