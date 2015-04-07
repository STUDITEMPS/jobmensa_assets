require 'refile'
require 'refile/backend/s3'

# MokeyPatch to fix signature content_length format
module Refile
  module Backend
    class S3
      def presign
        id = RandomHasher.new.hash
        signature = @bucket.presigned_post(key: [*@prefix, id].join('/'))
        signature = signature.where(:content_length).in(0..@max_size) if @max_size
        Signature.new(as: 'file', id: id, url: signature.url.to_s, fields: signature.fields)
      end
    end
  end
end