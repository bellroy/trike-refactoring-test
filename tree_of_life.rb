require 'pathname'

module StringHelper
  def ignore_case_eq(str1, str2)
    str1.casecmp(str2) == 0
  end

  def empty?(str)
    str.nil? || str == ''
  end
end

class Species
  def initialize(file_name)
    @file_name = file_name
  end

  def in_group?(group)
    groups.include? group.downcase
  end

  def data
    @data ||= parse_data(@file_name)
  end

  # Pattern used: #species, #name, etc. methods are like Adaptor's interface
  # were +data+ is Adaptee
  def species
    data[:species]
  end

  def name
    data[:name]
  end

  def eats
    data[:eats]
  end

  def move
    data[:move]
  end

  private

  def groups
    @groups ||= parse_groups(@file_name)
  end

  def parse_groups(file_name)
    file_name.downcase.split('/').inject({}) { |h, group|
      h.tap { h[group] = true }
    }
  end

  def parse_data(file_name)
    contents = File.read(file_name).split("\n")
    {
      species: File.basename(file_name).gsub('.life', '').gsub('_', ' '),
      name: contents[0].gsub('Name: ', ''),
      eats: contents[1].gsub('Eats: ', ''),
      move: contents[2].gsub('Move: ', '')
    }
  end
end

class TreeOfLife
  include StringHelper

  def initialize(path)
    @species = %x[find '#{path}' -name '*.life'].split("\n").map { |file_name|
      Species.new(file_name)
    }
  end

  def in_group(group)
    return [] if empty?(group)

    # Pattern used: procs here are like ConcreteStrategy instances
    #
    # most higher-order functions accepting proc are like Context accepting Strategy
    @species.select { |s| s.in_group?(group) }.map(&:data)
  end

  def all_that_eat(food)
    return [] if empty?(food)

    @species.select { |s| ignore_case_eq(s.eats, food) }.map(&:data)
  end

  def exercise_those_that(move)
    return '' if empty?(move)

    action = plural_for_move(move)

    "#{headline_for_move(move)}\n#{
      @species.select { |s| ignore_case_eq(s.move, move) }
              .map { |s| "The #{s.name} #{action}" }
              .join("\n")
    }"
  end

  def describe(species)
    return '' if empty?(species)

    match = @species.find { |s| ignore_case_eq(s.species, species) }
    if match.nil?
      "The species #{species} does not exist"
    else
      "The #{match.name} (#{match.species}) eats #{match.eats.downcase}" \
      " and #{plural_for_move(match.move)}"
    end
  end

  private

  MOVE_DETAILS = {
    'fly' => { headline: 'Look in the sky!', plural: 'flies' },
    'scuttle' => { headline: 'Look on the ground!', plural: 'scuttles' },
    'swim' => { headline: 'Look in the water!', plural: 'swims' }
  }

  def headline_for_move(move)
    (MOVE_DETAILS[move.downcase] || {})[:headline] || "There are no life forms that #{move}"
  end

  def plural_for_move(move)
    (MOVE_DETAILS[move.downcase] || {})[:plural]
  end
end
