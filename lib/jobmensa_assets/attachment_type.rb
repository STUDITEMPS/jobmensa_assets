require 'degu'

module JobmensaAssets
  enum :AttachmentType do
    field :content_type

    Image(
      content_type: ['image/jpeg', 'image/gif', 'image/png']
    )

    Spreadsheet(
      content_type: [
        'application/vnd.ms-excel', 'application/excel', # xls
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # xlsx
        'application/vnd.oasis.opendocument.spreadsheet' # ods
      ]
    )

    PDF(
      content_type: ['application/pdf']
    )

    Document(
      content_type: [
        'application/msword', 'application/word', 'application/x-msword', 'application/x-word', # doc
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document', # docx
        'application/vnd.oasis.opendocument.text', # odt
        'application/rtf', 'application/x-rtf', 'text/rtf', 'text/x-rtf' # rtf
      ]
    )

    def self.content_type(type)
      types_from(type).flat_map(&:content_type)
    end

    def self.file_extensions(type)
      types_from(type).flat_map(&:file_extensions)
    end

    def file_extensions
      @extensions ||= Hashie::Mash.new
      @extensions[underscored_name] ||= begin
        content_type.each_with_object([]) { |type, memo| memo << MIME::Types[type].flat_map(&:extensions) }.flatten.uniq
      end
    end

    def self.max_filesize(_type)
      Refile.cache.max_size
    end

    private

    def self.types_from(type)
      case type
      when Symbol, String
        Array(AttachmentType[type])
      when AttachmentType
        Array(type)
      when Refile::Type
        AttachmentType.for_refile_type(type)
      end
    end

    def self.for_refile_type(type)
      case type.name
      when :image
        Array(AttachmentType::Image)
      else
        AttachmentType.all
      end
    end

  end
end