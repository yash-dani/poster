class FiguresFetcherWorker
  include Sidekiq::Worker

  FIGURES_HOST = ENV['FIGURE_URL'] || "http://#{ENV['FIGURE_HOST'] || "localhost"}:4567"

  # TODO:
  # error handling for when image.save! fails
  # Fetches figures from external figure server and saves them
  def perform(figures_response, upload_id)
  	# TODO: raise on upload not yet created?
    @upload = Upload.find upload_id
    @upload.upload_figures.destroy_all if @upload.upload_figures.any?

    figures_response.each do |figure_blob|
      figure = @upload.upload_figures.new

      file_path = figure_blob["renderURL"]
      url = FIGURES_HOST + '/' + file_path

      figure.figure_type = set_figure_type(figure_blob)
      figure.caption = figure_blob["caption"]
      figure.page = figure_blob["page"]
      figure.name = figure_blob["name"]
      figure.image_remote_url = url

      figure.save!
    end

    # callback to figures host for /cleanup
    FiguresExtractService.cleanup(@upload.id)

  end

  def set_figure_type(figure_blob)
  	case figure_blob["figType"]
  	when "Figure"
  		"image"
  	when "Table"
  		"tabular"
  	end
  end
end
