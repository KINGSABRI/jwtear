module JWTear
  module Utils

    def encode(data)
      Base64.urlsafe_encode64(data, padding: false)
    end

    def decode(data)
      Base64.urlsafe_decode64(data)
    end

    def encode_header_payload(header, payload)
      [header, payload].map {|part| encode part}.join('.')
    end
  end
end