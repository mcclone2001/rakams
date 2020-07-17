class ResponderGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :topic, type: :string, banner: "topic", required: true

  def copy_initializer_file
    template "responder.erb", "app/responders/#{file_name}.rb"
  end
end
