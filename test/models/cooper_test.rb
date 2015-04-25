require 'test_helper'

class CooperTest < ActiveSupport::TestCase
  def setup
    @cooper = Cooper.new(fname: "Jim", lname: "Smith", number: "+11112223333", house: "Foster")
  end

  test "valid coopers are valid" do
    assert @cooper.valid?
  end

  test "sanitizes somewhat wrong legal phone numbers" do
    numbers = [
      "+17863738989",
      "11112223333",
      "1111-222-3333",
      "+1111 222 3333",
      "1(111) 222 3333",
      "1(111)-222-3333"
    ]

    numbers.each do |number|
      @cooper.number = number
      assert @cooper.valid?, "#{@cooper.number} from #{number} wasn't valid"
    end
  end

  test "does not take totally wrong numbers" do
    numbers = [
      "111-2223 334",
      "111-222334",
      "(11) 222 3333",
      "222-3333",
      "1112222"
    ]

    numbers.each do |number|
      @cooper.number = number
      assert_not @cooper.valid?, "#{@cooper.number} from #{number} shouldn't be valid"
    end
  end

  test "only allows one of the two houses" do
    @cooper.house = "not a house"
    assert_not @cooper.valid?
    @cooper.house = ["Elmwood","Foster"].sample
    assert @cooper.valid?
  end
end
