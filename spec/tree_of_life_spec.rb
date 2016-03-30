require_relative '../tree_of_life'

describe TreeOfLife do
  # changed the folder name in path from `Life On Earth` to `Life on Earth`
  # it was working fine on my machine( OSX ) which has a case-insensitive file system
  # but could break on any case-sensitive file system
  let(:tree_of_life) { TreeOfLife.new('spec/fixtures/Life on Earth') }

  describe '#in_group' do
    subject(:in_group) { tree_of_life.in_group(phylum) }

    context 'matching case' do
      let(:phylum) { 'Hexapoda' }
      specify do
        expect(in_group.first[:name]).to eq 'Ground beetle'
      end
    end

    context 'mismatching case' do
      let(:phylum) { 'dionycha' }
      specify do
        expect(in_group.first[:name]).to eq 'American Jumping Spider'
      end
    end

    context 'all matching' do
      let(:phylum) { 'Life on Earth' }
      specify { expect(in_group.length).to eq 7 }
    end

    context 'none matching' do
      let(:phylum) { 'Spice Girls' }
      specify { expect(in_group.length).to eq 0 }
    end

    context 'defensive coding' do
      let(:phylum) { nil }
      specify { expect(in_group.length).to eq 0 }
    end
  end

  describe '#all_that_eat' do
    subject(:all_that_eat) { tree_of_life.all_that_eat(food) }

    context 'multiple matching' do
      let(:food) { 'flies' }
      specify do
        expect(all_that_eat.length).to eq 2
        names = all_that_eat.map{|hash| hash[:name]}
        expect(names).to include 'American Jumping Spider'
        expect(names).to include 'Dracula Ant'
      end
    end

    context 'no matching' do
      let(:food) { 'burgers' }
      specify { expect(all_that_eat.length).to eq 0 }
    end

    context 'defensive coding' do
      let(:food) { nil }
      specify { expect(all_that_eat.length).to eq 0 }
    end
  end

  describe '#exercise_those_that' do
    subject(:exercise_those_that) { tree_of_life.exercise_those_that(move) }

    context 'fly' do
      let(:move) { 'fly' }
      specify do
        expect(exercise_those_that).to match /Look in the sky!/
        expect(exercise_those_that).to match /The African Wattled Lapwing flies/
        expect(exercise_those_that).to match /The Greytail flies/
        expect(exercise_those_that).to match /The Josia Moth flies/
      end
    end

    context 'scuttle' do
      let(:move) { 'scuttle' }
      specify do
        expect(exercise_those_that).to match /Look on the ground!/
        expect(exercise_those_that).to match /The American Jumping Spider scuttles/
        expect(exercise_those_that).to match /The Ground beetle scuttles/
        expect(exercise_those_that).to match /The Dracula Ant scuttles/
      end
    end

    context 'swim' do
      let(:move) { 'swim' }
      specify do
        expect(exercise_those_that).to match /Look in the water!/
        expect(exercise_those_that).to match /The Giant squid swims/
      end
    end

    context 'no matching' do
      let(:move) { 'skateboard' }
      specify do
        result = "There are no life forms that skateboard\n"
        expect(exercise_those_that).to eq result
      end
    end

    context 'defensive coding' do
      let(:move) { nil }
      specify { expect(exercise_those_that).to eq '' }
    end
  end

  describe '#describe' do
    subject(:description) { tree_of_life.describe(species) }

    context 'matching' do
      let(:species) { 'histioteuthis eltaninae' }
      specify do
        expect(description).to eq 'The Giant squid (histioteuthis eltaninae) ' \
                                  'eats plankton and swims'
      end
    end

    context 'no matching' do
      let(:species) { 'humanicas dropkickus' }
      specify do
        result = 'The species humanicas dropkickus does not exist'
        expect(description).to eq result
      end
    end

    context 'defensive coding' do
      let(:species) { nil }
      specify { expect(description).to eq '' }
    end
  end
end
