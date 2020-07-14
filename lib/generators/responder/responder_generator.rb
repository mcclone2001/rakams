class ResponderGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :topic, type: :string, default: [], banner: "topic"
  argument :object, type: :string, default: [], banner: "object"
  # argument :serializer, type: :string, default: [], banner: "topic"

  def copy_initializer_file
    template "responder.erb", "app/responders/#{class_name}.rb"
  end
end
