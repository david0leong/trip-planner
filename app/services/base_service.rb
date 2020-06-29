# Base class for all services that have #call interface
class BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    raise NotImplementedError
  end
end
