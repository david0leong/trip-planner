# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country, type: :model do
  describe '#in_boundary?' do
    subject do
      Country.new({
                    "id": 'FJI',
                    "iso2Code": 'FJ',
                    "name": 'Fiji',
                    "capitalCity": 'Suva',
                    "latitude": -18.1149,
                    "longitude": 178.399
                  })
    end

    it 'checks if the country is in boundary' do
      boundary = {
        min_latitude: -30,
        max_latitude: 30,
        min_longitude: 150,
        max_longitude: 179
      }

      expect(subject.in_boundary?(boundary)).to be true
    end

    it 'checks across antimeridian' do
      boundary = {
        min_latitude: -30,
        max_latitude: 30,
        min_longitude: 170,
        max_longitude: -170
      }

      expect(subject.in_boundary?(boundary)).to be true
    end
  end
end
