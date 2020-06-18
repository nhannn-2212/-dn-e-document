class Admin::HistoriesController < AdminController
  authorize_resource class: false

  def index
    @download_chart = History.group_by_month(:created_at, format: Settings.format_month_chart).count
    @upload_chart = Document.group_by_month(:created_at, format: Settings.format_month_chart).count
  end
end
