# frozen_string_literal: true

# CepController
class CepController < ApplicationController
  require 'net/http'

  def show
    cep = params[:zipcode].gsub(/[.-]/, '')
    url = URI("https://viacep.com.br/ws/#{cep}/json/")
    response = Net::HTTP.get_response(url)
    render json: response.body
  end
end
