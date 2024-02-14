module ExportObserver
  extend ActiveSupport::Concern

  included do
    after_update :create_file, if: -> { status == "done" }
  end

  private

  def create_file
    ExportFileJob.perform_later(id)
  end
end
