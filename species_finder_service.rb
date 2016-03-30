# None of the TreeOfLife or Species classes should be dealing with filesystems
# It's clearly not their responsibility, and as now we have 'Dr Reginald T Cranshaw' insisting on storing the lifeforms
# into a convoluted Directory structure, he can request later to fetch/merge data from other sources
# so it's better to extract a Lifeform/species finder service whose sole responsibility will be to
# find lifeForms from different sources and build species instances
# It's inspired by Service Oriented Architecture(SOA)

class SpeciesFinderService
  def self.find_species_from_path(path)
    files = %x[find '#{path}' -name '*.life'].split("\n")
    species = files.map { |file_name|
      Species.new(self.parse_species_data(file_name))
    }
    species
  end

  def self.parse_species_data(file)
    contents = File.read(file).split("\n")
    {
        groups:     file.downcase.split('/'),
        species_name: File.basename(file).gsub('.life', '').gsub('_', ' '),
        english_name: contents[0].gsub('Name: ', ''),
        food:         contents[1].gsub('Eats: ', ''),
        movement:     contents[2].gsub('Move: ', '')
    }
  end
end