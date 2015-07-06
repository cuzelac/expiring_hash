class ExpiringHash < Hash
  Struct.new("Value", :value, :ts)

  def initialize(default=nil, args={}, &block)
    @lifetime = args[:lifetime] || 30
    @time_impl = args[:time_impl] || Time

    @storage = {}

    super(default, &block)
  end

  def []=(key,val)
    @storage[key] = Struct::Value[val, @time_impl.now]
    super # stash this like a regular Hash so that it still prints out pretty
  end

  def delete(key)
    @storage.delete(key)
    super
  end

  def [](key)
    value = @storage[key]
    return nil unless value

    if is_expired?(value)
      delete(key)
      nil
    else
      value.value
    end
  end

  private
  def is_expired?(value)
    age = @time_impl.now - value.ts
    age >= @lifetime
  end
end
