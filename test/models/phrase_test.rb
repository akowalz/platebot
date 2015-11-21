require 'test_helper'

class PhraseTest < ActiveSupport::TestCase
  def setup
    @cooper = FactoryGirl.create(:cooper)
  end

  test "a cooper can only have 3 phrases" do
    3.times { @cooper.phrases.create( text: "have a great day!" ) }

    fourth_phrase = @cooper.phrases.new( text: "too many" )
    assert_not fourth_phrase.valid?
    assert_not_nil fourth_phrase.errors
  end

  test "phrases can only be up to 30 characters" do
    assert @cooper.phrases.new( text: "nice and short" ).valid?
    assert_not @cooper.phrases.new( text: "a" * 61 ).valid?
  end
end
