# frozen_string_literal: true

json.array! @issues, partial: 'issue', as: :issue
