class Id
    def self.generate
        SecureRandom.uuid
    end
end