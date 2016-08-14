module ActiveRecord
  class Base
    def association_loaded?(name)
      association_instance_get(name).present?
    end
  end
end
