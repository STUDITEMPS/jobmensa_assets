require 'refile'
require 'refile/attacher'

# Migration Content-Type (JM1) fix
module Refile
  class Attacher
    def download(url)
      unless url.to_s.empty?
        file = open(url)
        content_type = file.meta["content-type"]
        if content_type.blank?
          content_type = MIME::Types.type_for(::File.extname(file.base_uri.path).gsub('.', '')).first.content_type
        end
        @metadata = {
          size: file.meta["content-length"].to_i,
          filename: ::File.basename(file.base_uri.path),
          content_type: content_type
        }
        if valid?
          @metadata[:id] = cache.upload(file).id
          write_metadata
        elsif @raise_errors
          raise Refile::Invalid, @errors.join(", ")
        end
      end
    rescue OpenURI::HTTPError, RuntimeError => error
      raise if error.is_a?(RuntimeError) and error.message !~ /redirection loop/
      @errors = [:download_failed]
      raise if @raise_errors
    end
  end
end