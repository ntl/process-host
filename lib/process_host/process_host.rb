module ProcessHost
  def self.start env=nil, &block
    supervisor = Actor::Supervisor.new

    Host.build env, supervisor: supervisor, &block

    supervisor.start
  end
end
