# this class's sole responsibility is to hold Species Instance with
# all required data and answer if an species is inside a group
# it also has some aliases to
class Species
  attr_reader :species_name, :english_name, :food, :movement
  def initialize(args)
    # the arguments are received as a hash to remove Argument Order Dependency
    @species_name = args[:species_name]
    @english_name = args[:english_name]
    @food         = args[:food]
    @movement     = args[:movement]
    @groups       = args[:groups]
  end

  def in_group?(group)
    @groups.include? ( group.downcase )
  end

  # return all properties as a hash
  def properties_as_hash
    {
        species: species_name,
        name:    english_name,
        eats:    food,
        move:    movement
    }
  end
end