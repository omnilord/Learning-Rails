module StandardJSONWrapper
  extend ActiveSupport::Concern

  def render_json
    begin
      render json: {
        status: :ok,
        data: yield
      }
    rescue Exception => ex
      render json: {
        status: :internal_server_error,
        data: {
          msg: Rails.env.development? ? ex.message : "There was an error."
        }
      }
    end
  end
end
