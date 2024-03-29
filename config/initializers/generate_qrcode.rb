# frozen_string_literal: true

def generate_qrcode(text)
  require 'barby'
  require 'barby/barcode'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'

  barcode = Barby::QrCode.new(text, level: :q, size: 12)
  base64_output = Base64.encode64(barcode.to_png({ xdim: 5 }))
  "data:image/png;base64,#{base64_output}"
end
