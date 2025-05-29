# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Field, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:shape) }
  end
end
