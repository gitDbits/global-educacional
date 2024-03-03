# frozen_string_literal: true

require 'pagy/extras/bootstrap'
require 'pagy/extras/i18n'
require 'pagy/extras/overflow'

Pagy::DEFAULT[:items] = 5
Pagy::I18n.load(locale: 'pt', filepath: 'config/locales/pt.yml')
Pagy::DEFAULT[:page_param] = :pagina
Pagy::DEFAULT[:overflow] = :empty_page
