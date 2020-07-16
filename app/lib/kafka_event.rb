class KafkaEvent
    attr_accessor :id, :event_type, :data, :headers

    def initialize(data, headers={})
        @id ||= Id.generate
        @headers = headers.merge({id:@id})
        @data = data
        
        @event_type = headers[:event_type]
        # exito / fracaso / progreso - operacion
        # alta / baja / cambio - entidad
        #   data de la entidad (despues del alta, despues del cambio, antes de la baja)
        #   id de la entidad
        #   uri de la entidad
        #   updated_at de la entidad
        #   eventos relacionados (topico, id del evento)
        #       inicial
        #       previo
    end

end