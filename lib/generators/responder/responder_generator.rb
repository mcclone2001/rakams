class ResponderGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :topic, type: :string, default: [], banner: "topic"
  argument :object, type: :string, default: [], banner: "object"

  def copy_initializer_file
    template "responder.erb", "app/responders/#{file_name}_responder.rb"
  end
end
