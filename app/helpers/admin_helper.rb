module AdminHelper
  def statuses
    Document.statuses.except(:draft).keys.to_a
  end
end
