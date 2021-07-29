class ApplicationService
  private

  def storage
    @storage ||= Redis.new(url: "redis://localhost:6379/0")
  end
end
