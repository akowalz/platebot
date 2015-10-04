class DateTime
  def readable
    strftime("%A, %B %-e")
  end
end

class ActiveSupport::TimeWithZone
  def readable
    strftime("%A, %B %-e")
  end
end
