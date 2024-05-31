require 'csv'

class ExportFileJob < ApplicationJob
  queue_as :default

  def perform(export_id)
    # Do something later
    export = Export.find(export_id)
    return unless export.status == "done"

    content_csv = generate_contenu_csv(export)

    file_name = "export#{export.id}_#{export.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv"
    file_path = Rails.root.join("export_files", file_name)
    File.open(file_path, 'w') { |f| f.write content_csv }

    export.update(url: file_path.to_s)
    export.save
  end

  def generate_contenu_csv(export)
    CSV.generate(headers: true) do |csv|
      csv << export.params.keys
      csv << export.params.values
    end
  end
end
