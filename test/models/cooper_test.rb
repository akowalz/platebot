require 'test_helper'

class CooperTest < ActiveSupport::TestCase
  def setup
    @cooper = Cooper.new(fname: "Jim", lname: "Smith", number: "+11112223333", house_id: 1)
  end

  def teardown
    @cooper.destroy
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
      "1112222",
      "1284129847192847192847129847912874"
    ]

    numbers.each do |number|
      @cooper.number = number
      assert_not @cooper.valid?, "#{@cooper.number} from #{number} shouldn't be valid"
    end
  end

  test "does not allow two users to have the same phone number" do
    @cooper.save
    copy = Cooper.new(fname: "a", lname: "b", number: @cooper.number, house_id: 1)
    assert_not copy.valid?
    assert_not copy.save
  end

  test "it can find coopers with unclean numbers" do
    @cooper.save
    assert_equal @cooper, Cooper.find_by_uncleaned_number("111-222-3333")
  end
end
