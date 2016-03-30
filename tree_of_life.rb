require 'pathname'

module Helper
  def empty?(str)
    # nil, empty or just whitespace
    str.to_s.strip.length == 0
  end

  def case_insensitive_equal?(str1, str2)
    str1.downcase == str2.downcase
  end
end

class TreeOfLife
  include Helper
  def initialize(path)
    self.files = %x[find '#{path}' -name '*.life'].split("\n")
  end

  def in_group(group)
    return [] unless valid?(group)
    matching_files = files.select{ |file| file.downcase.split('/').include?(group.downcase) }
    matching_files.map{|file| file_to_hash(file)}
  end

  def all_that_eat(food)
    return [] unless valid?(food)
    files.map{|file| file_to_hash(file)}.select{|hash| case_insensitive_equal?( hash[:eats], food )}
  end

  def exercise_those_that(move)
    return '' unless valid?(move)
    matching_hashes = files.map{|file| file_to_hash(file)}.select{ |hash| case_insensitive_equal?( hash[:move] , move )}
    headline = headline_for_move(move)
    action   = action_for_move(move)
    "#{headline}\n#{matching_hashes.map{|hash| 'The ' + hash[:name] + ' ' + action}.join("\n")}"
  end

  def describe(species)
    return '' unless valid?(species)
    match = files.map{|file| file_to_hash(file)}.find{ |hash| case_insensitive_equal?( hash[:species] , species ) }
    if match.nil?
      "The species #{species} does not exist"
    else
      action = action_for_move(match[:move])
      "The #{match[:name]} (#{match[:species]}) eats #{match[:eats].downcase}" \
        " and #{action}"
    end
  end

  private

  attr_accessor :files

  MOVEMENT_DETAILS = {
      'fly'       => { headline: 'Look in the sky!',    action: 'flies' },
      'scuttle'   => { headline: 'Look on the ground!', action: 'scuttles' },
      'swim'      => { headline: 'Look in the water!',  action: 'swims' }
  }

  def headline_for_move(move)
    return MOVEMENT_DETAILS[move.downcase][:headline] unless MOVEMENT_DETAILS[move.downcase].nil?
    "There are no life forms that #{move}"
  end

  # it returns nil if an action for the move is not found
  def action_for_move(move)
    return MOVEMENT_DETAILS[move.downcase][:action] unless MOVEMENT_DETAILS[move.downcase].nil?
  end

  def valid?(arg)
    # our only check for a valid arguments to our public interfaces is if the argument string is not empty
    # but it's better to keep it self contained, so we only have a single place to change this
    # in future if need be
    !empty?(arg)
  end

  def file_to_hash(file)
    contents = File.read(file).split("\n")
    {
      species: File.basename(file).gsub('.life', '').gsub('_', ' '),
      name: contents[0].gsub('Name: ', ''),
      eats: contents[1].gsub('Eats: ', ''),
      move: contents[2].gsub('Move: ', '')
    }
  end
end
