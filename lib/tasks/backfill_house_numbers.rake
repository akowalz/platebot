namespace :backfill do
  desc "Backfill house number ids"
  task :backfill_house_ids => :environment do
    Cooper.all.each do |cooper|
      if cooper.house == "Foster"
        cooper.house_id = House.foster.id
      else
        cooper.house_id = House.elmwood.id
      end
      puts "Updating #{cooper.fname} #{cooper.lname} to #{cooper.house}"
      cooper.save!
    end
  end
end
