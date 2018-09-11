require 'spec_helper'

describe Quickfilter do
  it 'has a version number' do
    expect(Quickfilter::VERSION).not_to be nil
  end
end

describe ApplicationRecord do
  subject { ApplicationRecord }

  it { expect(subject.methods.include?(:filter)).to be(true) }
end

describe 'Queries' do
  before(:all) do
    john = User.create!(first_name: 'John', last_name: 'Smith', status: 0)
    eric = User.create!(first_name: 'Eric', last_name: 'Smith', status: 1)

    uni = University.create!(name: 'SLU')
    bsu = University.create!(name: 'BSU')

    Student.create(university: uni, user: john)
    Student.create(university: bsu, user: eric)
  end

  describe 'No Filter' do
    subject { User.filter({}) }

    it { expect(subject.is_a?(ActiveRecord::Relation)).to eq(true) }
    it { expect(subject.count).to eq(2) }
  end

  describe 'Basic Filter (Match)' do
    subject { User.filter(first_name: { likeic: 'jOhn' }, status: { in: [0, 1] }) }
    it { expect(subject.count).to eq(1) }
  end

  describe 'Basic Filter (Empty)' do
    subject { User.filter(first_name: { likeic: 'Adam' }, status: { in: [0, 1] }) }
    it { expect(subject.count).to eq(0) }
  end

  describe 'Join Filter (Match)' do
    subject { University.filter(name: { eq: 'SLU' }, 
                                users: { first_name: { likeic: 'john' }}) }
    it { expect(subject.count).to eq(1) }
  end

  describe 'Join Filter (Empty)' do
    subject { University.filter(name: { eq: 'SLU' }, 
                                users: { first_name: { likeic: 'eric' }}) }
    it { expect(subject.count).to eq(0) }
  end
end