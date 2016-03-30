require 'pathname'
require_relative 'string_helper'
require_relative 'species'
require_relative 'species_finder_service'

# This class has undergone massive refactoring, it now has only One responsibility which is holding a
# `Tree of Life` and providing Query and Action methods so `Dr Reginald T Cranshaw` can
# query data and can feed and exercise his specimens
# `Single Responsibility Pattern` was used to defer all unrelated responsibilities
# into their own service/classes

class TreeOfLife
  include StringHelper
  def initialize(path)
    @species = SpeciesFinderService.find_species_from_path(path)
  end

  def in_group(group)
    return [] unless valid?(group)
    @species.select { |s| s.in_group?(group)}.map(&:properties_as_hash)
  end

  def all_that_eat(food)
    return [] unless valid?(food)
    @species.select { |s| case_insensitive_equal?(s.food, food) }.map(&:properties_as_hash)
  end

  def exercise_those_that(movement)
    return '' unless valid?(movement)
    matching_species = @species.select{ |hash| case_insensitive_equal?( hash.movement , movement )}
    headline = headline_for_movement(movement)
    action   = action_for_movement(movement)
    "#{headline}\n#{matching_species.map{|hash| 'The ' + hash.english_name + ' ' + action}.join("\n")}"
  end

  def describe(species_name)
    return '' unless valid?(species_name)
    species = @species.find { |s| case_insensitive_equal?(s.species_name, species_name) }
    if species.nil?
      "The species #{species_name} does not exist"
    else
      action = action_for_movement(species.movement)
      "The #{species.english_name} (#{species.species_name}) eats #{species.food.downcase}" \
        " and #{action}"
    end
  end

  private

  MOVEMENT_DETAILS = {
      'fly'       => { headline: 'Look in the sky!',    action: 'flies' },
      'scuttle'   => { headline: 'Look on the ground!', action: 'scuttles' },
      'swim'      => { headline: 'Look in the water!',  action: 'swims' }
  }

  def headline_for_movement(move)
    return MOVEMENT_DETAILS[move.downcase][:headline] unless MOVEMENT_DETAILS[move.downcase].nil?
    "There are no life forms that #{move}"
  end

  # it returns nil if an action for the move is not found
  def action_for_movement(move)
    return MOVEMENT_DETAILS[move.downcase][:action] unless MOVEMENT_DETAILS[move.downcase].nil?
  end

  def valid?(arg)
    # our only check for a valid arguments to our public interfaces is if the argument string is not empty
    # but it's better to keep it self contained, so we only have a single place to change this
    # in future if need be
    !empty?(arg)
  end


end
