class Search < ActiveRecord::Base

  # Search records are never modified
  def readonly?
    true
  end

  # Our view doesn't have primary keys, so we need
  # to be explicit about how to tell different search
  # results apart; without this, we can't use :include
  # to avoid n + 1 query problems
  def hash
    [searchable_id, searchable_type, searchable_field].hash
  end

  def eql?(result)
    searchable_id == result.searchable_id &&
      searchable_type == result.searchable_type &&
      searchable_field == result.searchable_field
  end

  def source
    self.searchable_type.constantize.find(self.searchable_id)
  end
end
