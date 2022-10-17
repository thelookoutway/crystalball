# frozen_string_literal: true

require 'spec_helper'

describe Crystalball::Predictor::Gemfile do
  subject(:predictor) { described_class.new }
  let(:repository) { Git::Base.new }
  let(:path1) { 'Gemfile' }
  let(:file_diff1) { Crystalball::SourceDiff::FileDiff.new(Git::Diff::DiffFile.new(repository, path: path1)) }
  let(:diff) { [file_diff1] }
  let(:map) { instance_double('Crystalball::MapGenerator::ExecutionMap', example_groups: example_groups) }
  let(:example_groups) { {'spec_file' => [], 'spec_file_2' => [] } }

  describe '#call' do
    subject { predictor.call(diff, map) }

    it { is_expected.to eq(['./spec_file', './spec_file_2']) }

    context 'when gemfile.lock is included in changed files' do
      let(:path1) { 'Gemfile.lock' }

      it { is_expected.to eq(['./spec_file', './spec_file_2']) }
    end

    context 'when neither Gemfile or Gemfile.lock are changed' do
      let(:path1) { 'version.rb' }

      it { is_expected.to eq([]) }
    end
  end
end
