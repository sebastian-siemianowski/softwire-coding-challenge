module Services
  class BookingRequestsImporter
    attr_reader :filepath
    def initialize(file_name=nil)
      raise ArgumentError, 'Filename needs to be provided' unless file_name
      @filepath = ENV['BOOKING_IMPORT_PATH'] + "/" + file_name
    end
  end
end
