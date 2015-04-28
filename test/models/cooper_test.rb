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
      "7863738989",
      "1112223333",
      "111-222-3333",
      "111 222 3333",
      "(111) 222 3333",
      "(111)-222-3333"
    ]

    numbers.each do |number|
      @cooper.number = number
      assert @cooper.valid?, "#{@cooper.number} from #{number} wasn't valid"
    end
  end

  test "does not take totally wrong numbers" do
    numbers = [
      "11-2223 334",
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

  test "does not allow two users to have the same phone number" do
    @cooper.save
    copy = Cooper.new(fname: "a", lname: "b", number: @cooper.number, house: "Foster")
    assert_not copy.valid?
    assert_not copy.save
  end
end
