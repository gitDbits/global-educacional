# frozen_string_literal: true

RansackMemory::Core.config = {
  param: :q,
  session_key_format: '%controller_name%_%action_name%_%request_format%'
}
