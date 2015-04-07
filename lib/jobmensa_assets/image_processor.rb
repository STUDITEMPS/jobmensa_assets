require 'refile'
require 'refile/image_processing'

module JobmensaAssets
  ##
  # Processors for Refile
  class ImageProcessor < Refile::ImageProcessor

    ## do nothing
    def default(img)
    end

    ##
    # Overwrite refile call method to supress format warnings and do post-processing
    def call(file, *args, format: nil)
      img = ::MiniMagick::Image.new(file.path)
      img.quiet
      img.format(format.to_s.downcase, nil) if format
      send(@method, img, *args)
      post_processing(img)

      ::File.open(img.path, "rb")
    end

    private

    ##
    # Should be called for every jobmensa processor
    def post_processing(img)
      img.combine_options do |cmd|
        cmd.strip # Deletes metatags
        cmd.colorspace 'sRGB' # Change colorspace
        cmd.auto_orient # Reset rotation
        cmd.quiet # Suppress warnings
      end
    end
  end
end