module SessionsHelper
  def sign_in(cooper)
    cookies.permanent[:cooper_id] = cooper.id
  end

  def sign_out
    cookies[:cooper_id] = nil
    @current_user = nil
  end

  def current_user
    @current_user ||= Cooper.find_by(id: cookies[:cooper_id])
  end
end
