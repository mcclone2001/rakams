# frozen_string_literal: true

# A generic karafka consumer
class ConsumerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :topic, type: :string, banner: 'topic', required: true

  def copy_initializer_file
    template = fetch_template
    contenido = fetch_karafka_app_config_file
    unless contenido.match?(/#{template}/)
      contenido_modificado = contenido.sub(/consumer_groups.draw do/mi, template)
    end
    File.open('karafka.rb', 'wb') { |file| file.write(contenido_modificado) }
    template 'consumer.erb', "app/consumers/#{file_name}.rb"
  end

  def fetch_template
    [
      'consumer_groups.draw do',
      "    topic :#{topic} do",
      "      consumer #{class_name}",
      '    end'
    ].join("\n") + "\n"
  end

  def fetch_karafka_app_config_file
    contenido = ''
    File.open('karafka.rb', 'rb') { |file| contenido = file.read }
    contenido
  end
end
