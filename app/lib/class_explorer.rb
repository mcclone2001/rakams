class ClassExplorer
    def self.get_attributes(clase)
        clase.attribute_names.map(&:to_sym)
    end

    def self.get_attributes_except(clase,exceptions)
        list_of_attributes = clase.attribute_names
        list_of_attributes -= exceptions
        list_of_attributes.map(&:to_sym)
    end
end
