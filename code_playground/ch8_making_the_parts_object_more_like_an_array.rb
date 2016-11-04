require 'forwardable'
class Parts
  extend Forwardable
  # .size and .each are forwarded to @parts.size and @parts.each
  def_delegators :@parts, :size, :each

  # Enumerable requires Parts to implement #each. #each is implemented by
  # forwarding it to @parts.each
  # Enumerable gives Parts many transversal an searching methods for collections
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    # #select is included in Parts through Enumerable. Enumerable in turn
    # depends on #each, which is forwarded to @parts
    select {|part| part.needs_spare}
  end
end

class Part
  attr_reader :name, :description, :needs_spare

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @needs_spare = args.fetch(:needs_spare, true)
  end

end

chain = Part.new(name: 'chain', description: '10-speed', needs_spare: false)
road_tire = Part.new(name: 'tire', desciption: 'slim')
road_bike_parts = Parts.new([chain, road_tire])
