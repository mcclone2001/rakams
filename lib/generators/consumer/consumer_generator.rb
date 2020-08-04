# frozen_string_literal: true

# A generic karafka consumer
class ConsumerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :topic, type: :string, banner: 'topic', required: true

  def copy_initializer_file
    template 'consumer.erb', "app/consumers/#{file_name}.rb"
  end
end
