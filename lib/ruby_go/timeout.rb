class RubyGo::Timeout
  def initialize(seconds)
    @mutex = Mutex.new
    @timeout = false
    @timeout_at = Time.now() + seconds
  end

  def pop(non_block = true)
    return true if @timeout

    @mutex.synchronize do
      diff = @timeout_at - Time.now()
      @timeout = true if diff <= 0.001
    end

    if @timeout
      true
    else
      raise ThreadError
    end
  end
end
