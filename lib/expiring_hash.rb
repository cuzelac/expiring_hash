class ExpiringHash < Hash
  def initialize(default=nil, args={}, &block)
    @lifetime = args[:lifetime] || 30
    @time_impl = args[:time_impl] || Time

    @timestamps = {}

    super(default, &block)
  end

  def []=(key,val)
    @timestamps[key] = @time_impl.now.to_i
    super
  end

  # TODO: might not need to override this at all if we can let @timestamps grow stale
  #       need to think that out
  def delete(key)
    @timestamps.delete(key)
    super
  end

  def [](key)
    value = super
    return nil unless value

    if is_expired?(key)
      delete(key)
      nil
    else
      value
    end
  end

  private

  def is_expired?(key)
    age = @time_impl.now.to_i - @timestamps[key]
    age >= @lifetime
  end
end
