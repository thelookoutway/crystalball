require 'crystalball/predictor/strategy'

module Crystalball
  class Predictor
    # Used with `predictor.use Crystalball::Predictor::Gemfile.new`. Return every file if the Gemfile or Gemfile.lock file are changed
    class Gemfile
      include Strategy

      # @param [Crystalball::SourceDiff] diff - the diff from which to predict
      #   which specs should run
      # @param [Crystalball::ExampleGroupMap] map - the map with the relations of
      #   examples and used files
      # @return [Array<String>] the spec paths associated with the changes
      def call(diff, map)
        super do
          return [] unless diff.detect{ |file_diff| ['Gemfile', 'Gemfile.lock'].include?(file_diff.path) }
          map.example_groups.keys.compact
        end
      end

      private

      attr_reader :spec_pattern
    end
  end
end
