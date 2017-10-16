# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

include FactoryGirl::Syntax::Methods

DatabaseCleaner.clean_with(:truncation)

puts "Creating houses"
houses = [
  the_zooo = House.create(name: House::Mosaic::THE_ZOOO),
  the_treehouse = House.create(name: House::Mosaic::THE_TREEHOUSE),
]


puts "Creating coopers"
10.times do
  houses.each do |house|
    create(
      :cooper,
      house: house,
    )
  end
end

create(:cooper, :admin)

puts "Creating late plates"
Cooper.all.each do |cooper|
  create(:late_plate, cooper: cooper)
  create(:late_plate, :past, cooper: cooper)

  if rand > 0.5
    create(:late_plate, :for_today, cooper: cooper)
  end

  5.times do |day|
    if rand > 0.8
      create(:repeat_plate, cooper: cooper, day: day)
    end
  end
end
