module StandardJSONWrapper
  extend ActiveSupport::Concern

  def render_json
    wrapper = {}

    begin
      wrapper[:data] = yield
    rescue Exception => ex
      wrapper[:status] = :internal_server_error
      flash[:danger] = Rails.env.development? ? ex.message : "There was an error."
    end

    wrapper[:flash] = flash.to_hash
    render json: wrapper
    flash.clear
  end

  def render_status(code)
    render status: code, nothing: true
  end
end
