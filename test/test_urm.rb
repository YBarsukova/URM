# frozen_string_literal: true

require_relative "test_helper"

class TestUrm < Minitest::Test
  def test_that_it_has_a_version
    refute_nil ::Urm::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end
