module Burning_Glass
  class Client
    attr_reader :instanceCode, :wsdl

    #Initialize the client class that will be used for all Burning_Glass requests.
    #
    # @param [Hash] options
    # @option options String :wsdl The url for the Burning Glass wsdl
    # @option options Integer :instanceCode The unique instance code for your version of the Burning Glass service

    def initialize(options={})
      @wsdl = options[:wsdl]
      @instanceCode = options[:instanceCode] || "YOUR_BURNING_GLASS_INSTANCE_CODE_CAN_GO_HERE"
    end

    def connection
      Savon.client(wsdl: wsdl, log: false)
    end

    def parse(file)
      result = connection.call(:tag_binary_data, message: {InstanceCode: @instanceCode, BinaryData: Base64.encode64(file)})
      Resume.parse(result.body[:tag_binary_data_response][:tag_binary_data_return])
    end

  end
end